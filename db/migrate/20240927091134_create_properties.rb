class CreateProperties < ActiveRecord::Migration[7.2]
  def change
    create_table :properties do |t|
      t.string :external_id, null: false
      t.string :name, null: false
      t.string :address
      t.string :room_number
      t.integer :rent
      t.float :area_square_meters
      t.integer :property_type, default: 0, null: false

      t.timestamps
    end

    add_index :properties, :external_id, unique: true
  end
end
