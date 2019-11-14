class AddFieldsTo1930Census < ActiveRecord::Migration[5.2]
  def change
    change_table :census_1930_records do |t|
      t.integer :homemaker, after: :relation_to_head
      t.integer :age_months, after: :age
      t.string :apartment_number, after: :street_suffix
    end
    change_table :census_1920_records do |t|
      t.string :apartment_number, after: :street_suffix
      t.integer :age_months, after: :age
    end
    change_table :census_1910_records do |t|
      t.string :apartment_number, after: :street_suffix
      t.integer :age_months, after: :age
    end
    change_table :census_1900_records do |t|
      t.string :apartment_number, after: :street_suffix
      t.integer :age_months, after: :age
    end
  end
end
