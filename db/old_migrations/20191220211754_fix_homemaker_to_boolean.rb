class FixHomemakerToBoolean < ActiveRecord::Migration[5.2]

  def convert_boolean_up(column)
    add_column :census_1930_records, "#{column}_bool", :boolean, after: column
    execute "update census_1930_records SET #{column}_bool='t' WHERE #{column}=1"
    execute "update census_1930_records SET #{column}_bool='f' WHERE #{column}=0"
    rename_column :census_1930_records, column, "#{column}_int"
    rename_column :census_1930_records, "#{column}_bool", column
  end

  def up
    convert_boolean_up :homemaker
  end

  def down

  end
end
