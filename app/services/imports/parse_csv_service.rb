require "csv"

# Description: This service is responsible for parsing a CSV file
# and importing the properties into the database.
module Imports
  class ParseCsvService
    include Callable

    class InvalidCsvHeadersError < StandardError; end

    class InvalidCsvRowsError < StandardError
      attr_reader :failed_instances

      # Initialize the error with the failed instances
      # @param [Array<Property>] failed_instances | The properties that failed to be imported
      # @return [void]
      def initialize(failed_instances)
        @failed_instances = failed_instances
      end
    end

    HEADERS = {
      "ユニークID" => :external_id,
      "物件名" => :name,
      "住所" => :address,
      "部屋番号" => :room_number,
      "賃料" => :rent,
      "広さ" => :area_square_meters,
      "建物の種類" => :property_type
    }

    PROPERTY_TYPES_MAPPING = {
      "アパート" => :appartment,
      "マンション" => :mansion,
      "一戸建て" => :house
    }

    # Initialize the service with the import history
    # @param [ImportHistory] import_history | The import history containing the CSV file to be parsed and imported
    # @return [void]
    def initialize(import_history:)
      @import_history = import_history
    end

    # Parse the CSV file and import the properties
    # @return [void]
    def call
      return unless @import_history.import_status_started?

      ActiveRecord::Base.transaction do
        @import_history.imported_file.open do |file|
          properties = []

          raise InvalidCsvHeadersError unless CSV.open(file, headers: true).first.headers.sort == HEADERS.keys.sort

          ################################
          #### 1. Properties creation ####
          ################################

          CSV.foreach(file, headers: true, header_converters: lambda { |header| HEADERS[header] }) do |row|
            properties << Property.new(
              external_id: row[:external_id],
              name: row[:name],
              address: row[:address],
              room_number: row[:room_number],
              rent: row[:rent],
              area_square_meters: row[:area_square_meters],
              property_type: PROPERTY_TYPES_MAPPING[row[:property_type]]
            )
          end

          import = Property.import(
            properties,
            on_duplicate_key_update: {conflict_target: [:external_id], columns: :all},
            all_or_none: true,
            validate: true,
            recursive: true
          )

          raise InvalidCsvRowsError.new(import.failed_instances) if import.failed_instances.any?

          #############################################
          #### 2. ImportHistoriesProperty creation ####
          #############################################

          import_histories_properties = []
          import.ids.map do |id|
            import_histories_properties << ImportHistoriesProperty.new(property_id: id, import_history_id: @import_history.id)
          end

          ImportHistoriesProperty.import!(import_histories_properties, on_duplicate_key_ignore: true, all_or_none: true)

          ###############################################
          #### 3. `imported_properties_count` update ####
          ###############################################

          @import_history.update!(imported_properties_count: import.ids.size)
        end
      end

      @import_history.update!(import_status: :completed)
    rescue InvalidCsvHeadersError
      @import_history.update!(import_status: :failed, import_failure_type: :invalid_headers)
    rescue InvalidCsvRowsError => e
      attach_error_csv(e.failed_instances)
      @import_history.update!(import_status: :failed, import_failure_type: :invalid_rows)
    rescue => e
      @import_history.update!(import_status: :failed, import_failure_type: :unknown_error)
      raise e
    end

    private

    # Create a CSV file with the rows that failed to be imported and attach it to the import history
    # @param [Array<Property>] invalid_properties | The properties that failed to be imported
    # @return [void]
    def attach_error_csv(invalid_properties)
      error_csv_content = CSV.generate do |csv|
        csv << HEADERS.keys + ["エラーメッセージ"]

        invalid_properties.each do |invalid_property|
          csv << invalid_property.attributes.values_at(*HEADERS.values.map(&:to_s)) + invalid_property.errors.full_messages
        end
      end

      @import_history.imported_file_with_errors.attach(
        io: StringIO.new(error_csv_content),
        filename: "#{@import_history}-errors.csv",
        content_type: "text/csv"
      )
    end
  end
end
