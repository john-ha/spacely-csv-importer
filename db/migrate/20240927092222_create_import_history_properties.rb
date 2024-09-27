class CreateImportHistoryProperties < ActiveRecord::Migration[7.2]
  def change
    create_join_table :import_histories, :properties do |t|
      t.index :import_history_id
      t.index :property_id

      t.index %i[import_history_id property_id], unique: true

      t.timestamps
    end
  end
end
