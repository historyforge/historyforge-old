class AddCityDirectory < ActiveRecord::Migration[4.2]
  def change

    rename_table :census_records, :census_1910_records
    remove_column :census_1910_records, :type

    create_table :people do |t|
      t.jsonb :data
      t.timestamps null: false
    end

    add_column :census_1910_records, :person_id, :integer, index: true, unique: true

    create_table :census_1900_records do |t|
      t.jsonb :data
      t.references :building, index: true, foreign_key: true
      t.integer :person_id, index: true
      t.timestamps null: false
    end

    create_table :census_1920_records do |t|
      t.jsonb :data
      t.references :building, index: true, foreign_key: true
      t.integer :person_id, index: true
      t.timestamps null: false
    end

    add_foreign_key :census_1900_records, :people, column: :person_id
    add_foreign_key :census_1910_records, :people, column: :person_id
    add_foreign_key :census_1920_records, :people, column: :person_id

  end
end
