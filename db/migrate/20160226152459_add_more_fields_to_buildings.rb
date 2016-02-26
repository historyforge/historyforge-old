class AddMoreFieldsToBuildings < ActiveRecord::Migration
  def change
    create_table :construction_materials do |t|
      t.string :name
      t.string :color
      t.timestamps null: false
    end
    change_table :buildings do |t|
      t.string :address_house_number, before: :address
      t.string :address_street_prefix, before: :address
      t.string :address_street_name, before: :address
      t.string :address_street_suffix, before: :address
      t.integer :stories, before: :created_at
      t.text :annotations, before: :description
      t.integer :lining_type_id, before: :annotations
      t.integer :frame_type_id, before: :annotations
    end
    add_index :buildings, :lining_type_id
    add_index :buildings, :frame_type_id
  end
end
