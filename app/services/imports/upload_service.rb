module Imports
  class UploadService
    include Callable

    # Initialize the service with the file to be uploaded
    # @param [ActionDispatch::Http::UploadedFile] file
    # @return [void]
    def initialize(file:)
      @file = file
    end

    def call
      ActiveRecord::Base.transaction do
        import_history = ImportHistory.create!(import_status: :in_progress, imported_at: Time.zone.now)
        import_history.imported_file.attach(io: @file, filename: "#{import_history.id}.#{File.extname(@file.original_filename)}")

        ImportPropertiesJob.perform_later(import_history.id)
      end
    end
  end
end
