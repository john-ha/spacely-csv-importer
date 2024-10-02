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

    BATCH_SIZE = 2000

    # Initialize the service with the import history
    # @param [ImportHistory] import_history | The import history containing the CSV file to be parsed and imported
    # @return [void]
    def initialize(import_history:)
      @import_history = import_history
      @properties = []
      @failed_instances = []
      @properties_count = 0
    end

    # Parse the CSV file and import the properties
    # @return [void]
    def call
      return unless @import_history.import_status_started?

      ActiveRecord::Base.transaction do
        @import_history.imported_file.open do |file|
          raise InvalidCsvHeadersError unless CSV.open(file, headers: true).first.headers.sort == HEADERS.keys.sort

          ##########################################################
          #### 1. Properties & ImportHistoryProperties creation ####
          ##########################################################

          CSV.foreach(file, headers: true, header_converters: lambda { |header| HEADERS[header] }).with_index do |row, index|
            @properties << Property.new(
              external_id: row[:external_id],
              name: row[:name],
              address: row[:address],
              room_number: row[:room_number],
              rent: row[:rent],
              area_square_meters: row[:area_square_meters],
              property_type: PROPERTY_TYPES_MAPPING[row[:property_type]]
            )

            import_properties if @properties.size >= BATCH_SIZE
          end

          # Import the remaining properties of the last batch
          import_properties if @properties.any?

          raise InvalidCsvRowsError.new(@failed_instances) if @failed_instances.any?

          ###############################################
          #### 2. `imported_properties_count` update ####
          ###############################################

          @import_history.update!(imported_properties_count: @properties_count)
        end
      end

      @import_history.update!(import_status: :completed)

      Rails.logger.info("[Imports::ParseCsvService] Completed.")
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

    # Import the properties and the import histories properties
    # @return [void]
    def import_properties
      import = Property.import(
        @properties,
        on_duplicate_key_update: {conflict_target: [:external_id], columns: :all},
        all_or_none: true,
        validate: true,
        recursive: true
      )

      @failed_instances += import.failed_instances

      # If there are failed instances, do not even try to create the ImportHistoriesProperty records
      # We still want to continue parsing the CSV file to get all the possible failed instances and output them in the error CSV
      unless @failed_instances.any?
        import_histories_properties = import.ids.map do |id|
          ImportHistoriesProperty.new(property_id: id, import_history_id: @import_history.id)
        end

        ImportHistoriesProperty.import!(import_histories_properties, on_duplicate_key_ignore: true, all_or_none: true)
      end

      @properties = []
      @properties_count += import.ids.size
    end

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
