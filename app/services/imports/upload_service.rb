module Imports
  class UploadService
    include Callable

    class InvalidFileFormatError < StandardError; end

    class FileSizeExceededError < StandardError; end

    MAX_FILE_SIZE = 10.megabytes.freeze

    # Initialize the service with the file to be uploaded
    # @param [ActionDispatch::Http::UploadedFile] file
    # @return [void]
    def initialize(file:)
      @file = file
    end

    def call
      raise InvalidFileFormatError unless @file.content_type == "text/csv"
      raise FileSizeExceededError if @file.size > MAX_FILE_SIZE

      ActiveRecord::Base.transaction do
        import_history = ImportHistory.create!(import_status: :started, imported_at: Time.zone.now)
        import_history.imported_file.attach(io: @file, filename: "#{import_history.id}.#{File.extname(@file.original_filename)}")

        ImportPropertiesJob.perform_later(import_history.id)
      end
    end
  end
end
