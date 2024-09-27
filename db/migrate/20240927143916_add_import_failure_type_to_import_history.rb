class AddImportFailureTypeToImportHistory < ActiveRecord::Migration[7.2]
  def change
    add_column :import_histories, :import_failure_type, :integer
  end
end
