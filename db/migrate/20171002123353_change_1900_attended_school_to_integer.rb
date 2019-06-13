class Change1900AttendedSchoolToInteger < ActiveRecord::Migration[4.2]
  def change
    rename_column :census_1900_records, :attended_school, :attended_school_old
    add_column :census_1900_records, :attended_school, :integer
  end
end
