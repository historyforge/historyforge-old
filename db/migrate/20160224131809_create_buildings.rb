class CreateBuildings < ActiveRecord::Migration
  def change

    create_table :architects do |t|
      t.string :name, null: false
      t.timestamps null: false
    end

    create_table :building_types do |t|
      t.string :name, null: false
      t.timestamps null: false
    end

    create_table :buildings do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.string :city, null: false, default: 'Ithaca'
      t.string :state, null: false, default: 'NY'
      t.string :postal_code, null: false, default: '14850'
      t.integer :year_earliest
      t.integer :year_latest
      t.references :building_type, index: true, foreign_key: true
      t.text :description
      t.decimal  :lat,        precision: 15, scale: 10
      t.decimal  :lon,        precision: 15, scale: 10
      t.timestamps null: false
    end

    create_join_table :architects, :buildings
    add_index :architects_buildings, [:architect_id, :building_id], name: 'architects_buildings_index', unique: true
  end
end
