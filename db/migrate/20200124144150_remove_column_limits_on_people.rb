class RemoveColumnLimitsOnPeople < ActiveRecord::Migration[5.2]
  def change
    change_column :census_1900_records, :sex, :string, limit: nil
    change_column :census_1900_records, :race, :string, limit: nil
    change_column :census_1900_records, :marital_status, :string, limit: nil
    change_column :census_1900_records, :owned_or_rented, :string, limit: nil
    change_column :census_1900_records, :mortgage, :string, limit: nil
    change_column :census_1900_records, :farm_or_house, :string, limit: nil
    change_column :census_1910_records, :sex, :string, limit: nil
    change_column :census_1910_records, :race, :string, limit: nil
    change_column :census_1910_records, :marital_status, :string, limit: nil
    change_column :census_1910_records, :owned_or_rented, :string, limit: nil
    change_column :census_1910_records, :mortgage, :string, limit: nil
    change_column :census_1910_records, :farm_or_house, :string, limit: nil
    change_column :census_1920_records, :sex, :string, limit: nil
    change_column :census_1920_records, :race, :string, limit: nil
    change_column :census_1920_records, :marital_status, :string, limit: nil
    change_column :census_1920_records, :owned_or_rented, :string, limit: nil
    change_column :census_1920_records, :mortgage, :string, limit: nil
    change_column :census_1920_records, :farm_or_house, :string, limit: nil
    change_column :census_1930_records, :sex, :string, limit: nil
    change_column :census_1930_records, :race, :string, limit: nil
    change_column :census_1930_records, :marital_status, :string, limit: nil
    change_column :census_1930_records, :owned_or_rented, :string, limit: nil
  end
end
