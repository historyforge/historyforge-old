class AddFieldsTo1920Census < ActiveRecord::Migration
  def change
    change_table :census_1900_records do |t|
      t.string :name_prefix, after: :middle_name
      t.string :name_suffix, after: :name_prefix
    end
    change_table :census_1910_records do |t|
      t.string :name_prefix, after: :middle_name
      t.string :name_suffix, after: :name_prefix
    end
    change_table :census_1920_records do |t|
      t.string :name_prefix, after: :middle_name
      t.string :name_suffix, after: :name_prefix
      t.integer :year_naturalized, after: :naturalized_alien
      t.integer :farm_schedule, after: :employment
    end
    change_table :census_1930_records do |t|
      t.string :name_prefix, after: :middle_name
      t.string :name_suffix, after: :name_prefix
    end
  end
end
