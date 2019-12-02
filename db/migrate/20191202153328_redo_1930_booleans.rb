class Redo1930Booleans < ActiveRecord::Migration[5.2]
  def convert_boolean_up(column)
    # tmp_name = "#{column}_int"
    # add_column :census_1930_records, tmp_name, :integer, after: column
    execute "update census_1930_records SET #{column}_bool='t' WHERE #{column}=1"
    execute "update census_1930_records SET #{column}_bool='f' WHERE #{column}=0"
    rename_column :census_1930_records, column, "#{column}_int"
    rename_column :census_1930_records, "#{column}_bool", column
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

    change_column :census_1930_records, :race, :string, limit: 5

    Census1930Record.where(race: 'B').update_all(race: 'Neg')
    Census1930Record.where(worker_class: 'e').update_all(worker_class: 'E')
    Census1930Record.where(worker_class: 'w').update_all(worker_class: 'W')
    Census1930Record.where(worker_class: 'o').update_all(worker_class: 'O')
    Census1930Record.where(worker_class: 'np').update_all(worker_class: 'NP')
  end

  def down
    raise 'Ouch cannot do this sir'
  end
end
