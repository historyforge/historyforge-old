class AddIndustryTo1900Census < ActiveRecord::Migration[4.2]
  def change
    add_column :census_1900_records, :industry, :string, after: :profession
    add_column :census_1900_records, :farm_schedule, :integer, after: :farm_or_house
  end
end
