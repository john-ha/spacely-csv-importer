require "csv"

# Description: This job is responsible for importing properties from a CSV file.
class ImportPropertiesJob < ApplicationJob
  limits_concurrency to: 1, key: "import_properties_job", duration: 90.seconds

  queue_as :default

  # Import properties from a CSV file
  # @param [Integer] import_history_id | The ID of the import history
  # @return [void]
  def perform(import_history_id)
    import_history = ImportHistory.find(import_history_id)

    return unless import_history.import_status_enqueued?

    import_history.update!(import_status: :started)

    Imports::ParseCsvService.call(import_history:)
  end
end
