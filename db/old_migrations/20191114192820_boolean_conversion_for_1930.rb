class BooleanConversionFor1930 < ActiveRecord::Migration[5.2]
  def convert_boolean_up(column)
    tmp_name = "#{column}_int"
    add_column :census_1930_records, tmp_name, :integer, after: column
    execute "update census_1930_records SET #{tmp_name}=1 WHERE #{column}='t'"
    execute "update census_1930_records SET #{tmp_name}=0 WHERE #{column}='f'"
    rename_column :census_1930_records, column, "#{column}_bool"
    rename_column :census_1930_records, tmp_name, column
  end
  def up
    convert_boolean_up :has_radio
    convert_boolean_up :lives_on_farm
    convert_boolean_up :attended_school
    convert_boolean_up :can_read_write
    convert_boolean_up :can_speak_english
    convert_boolean_up :worked_yesterday
    convert_boolean_up :veteran
    convert_boolean_up :foreign_born
  end
  def down
    # convert_boolean_up :has_radio
    # convert_boolean_up :lives_on_farm
    # convert_boolean_up :attended_school
    # convert_boolean_up :can_read_write
    # convert_boolean_up :can_speak_english
    # convert_boolean_up :worked_yesterday
    # convert_boolean_up :veteran
    # convert_boolean_up :foreign_born
  end
end
