class AllowMaritalStatusToBeLonger < ActiveRecord::Migration[5.2]
  def change
    change_column :census_1900_records, :marital_status, :string, limit: 5
    change_column :census_1910_records, :marital_status, :string, limit: 5
    change_column :census_1920_records, :marital_status, :string, limit: 5
    change_column :census_1930_records, :marital_status, :string, limit: 5
  end
end
