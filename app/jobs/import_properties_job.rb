require "csv"

# Description: This job is responsible for importing properties from a CSV file.
class ImportPropertiesJob < ApplicationJob
  limits_concurrency to: 1, key: "import_properties_job", duration: 90.seconds

  queue_as :default

  retry_on ActiveStorage::FileNotFoundError, wait: 5.seconds, attempts: 3

  # Import properties from a CSV file
  # @param [Integer] import_history_id | The ID of the import history
  # @return [void]
  def perform(import_history_id)
    import_history = ImportHistory.find(import_history_id)

    Imports::ParseCsvService.call(import_history:)
  end
end
