class AddEmploymentCodeTo1920 < ActiveRecord::Migration[6.0]
  def change
    add_column :census_1920_records, :employment_code, :string, after: :employment
  end
end
