# Description: this service is responsible for uploading a file,
# attaching it to an import history,
# and enqueuing a job to import the properties.
module Imports
  class UploadService
    include Callable

    class InvalidFileFormatError < StandardError; end

    class FileSizeExceededError < StandardError; end

    MAX_FILE_SIZE = 20.megabytes.freeze

    # Initialize the service with the file to be uploaded
    # @param [ActionDispatch::Http::UploadedFile] file
    # @return [void]
    def initialize(file:)
      @file = file
    end

    # Uploads the file and enqueues a job to import the properties
    # @return [Integer] the ID of the created import history
    def call
      raise InvalidFileFormatError unless @file.content_type == "text/csv"
      raise FileSizeExceededError if @file.size > MAX_FILE_SIZE

      ActiveRecord::Base.transaction do
        import_history = ImportHistory.create!(import_status: :started, imported_at: Time.zone.now)
        import_history.imported_file.attach(io: @file, filename: "#{import_history.id}.#{File.extname(@file.original_filename)}")

        ImportPropertiesJob.perform_later(import_history.id)

        import_history
      end
    end
  end
end
