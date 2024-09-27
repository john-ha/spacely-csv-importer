require "csv"

# Description: This job is responsible for importing properties from a CSV file.
class ImportPropertiesJob < ApplicationJob
  queue_as :default

  # Import properties from a CSV file
  # @param [Integer] import_history_id | The ID of the import history
  # @return [void]
  def perform(import_history_id)
    import_history = ImportHistory.find(import_history_id)

    Imports::ParseCsvService.new(import_history:).call
  end
end
