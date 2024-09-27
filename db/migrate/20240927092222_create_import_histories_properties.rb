class CreateImportHistoriesProperties < ActiveRecord::Migration[7.2]
  def change
    create_table :import_histories_properties do |t|
      t.references :import_history, null: false, foreign_key: true
      t.references :property, null: false, foreign_key: true

      t.timestamps
    end

    add_index :import_histories_properties, [:import_history_id, :property_id], unique: true
  end
end
