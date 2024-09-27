class CreateImportHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :import_histories do |t|
      t.integer :import_status, default: 0, null: false
      t.integer :imported_properties_count, default: 0, null: false
      t.datetime :imported_at, null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.timestamps
    end
  end
end
