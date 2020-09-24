class FromBuildingTypeToBuildingTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :buildings_building_types, id: false do |t|
      t.references :building, foreign_key: true
      t.references :building_type, foreign_key: true
    end
    change_table :buildings_building_types do |t|
      t.index [:building_id, :building_type_id], unique: true, name: 'buildings_building_types_unique_index'
    end
    reversible do |dir|
      dir.up do
        Building.find_each do |building|
          building.building_type_ids = [building.building_type_id]
          building.save
        end
      end
    end
  end
end
