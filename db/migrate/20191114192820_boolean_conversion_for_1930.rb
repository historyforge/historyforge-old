class BooleanConversionFor1930 < ActiveRecord::Migration[5.2]
  def up
    change_column :census_1930_records, :has_radio, :integer, using: "CASE WHEN 'f' THEN 0 WHEN 't' THEN 1 ELSE NULL END"
    change_column :census_1930_records, :lives_on_farm, :integer, using: "CASE WHEN 'f' THEN 0 WHEN 't' THEN 1 ELSE NULL END"
    change_column :census_1930_records, :attended_school, :integer, using: "CASE WHEN 'f' THEN 0 WHEN 't' THEN 1 ELSE NULL END"
    change_column :census_1930_records, :can_read_write, :integer, using: "CASE WHEN 'f' THEN 0 WHEN 't' THEN 1 ELSE NULL END"
    change_column :census_1930_records, :can_speak_english, :integer, using: "CASE WHEN 'f' THEN 0 WHEN 't' THEN 1 ELSE NULL END"
    change_column :census_1930_records, :worked_yesterday, :integer, using: "CASE WHEN 'f' THEN 0 WHEN 't' THEN 1 ELSE NULL END"
    change_column :census_1930_records, :veteran, :integer, using: "CASE WHEN 'f' THEN 0 WHEN 't' THEN 1 ELSE NULL END"
    change_column_default :census_1930_records, :foreign_born, nil
    change_column :census_1930_records, :foreign_born, :integer, using: "CASE WHEN 'f' THEN 0 WHEN 't' THEN 1 ELSE NULL END"
    change_column_default :census_1930_records, :foreign_born, 0
  end
  def down
    change_column :census_1930_records, :has_radio, :boolean, using: "CASE WHEN 0 THEN 'f 'WHEN 1 THEN 't' ELSE NULL END"
    change_column :census_1930_records, :lives_on_farm, :boolean, using: "CASE WHEN 0 THEN 'f 'WHEN 1 THEN 't' ELSE NULL END"
    change_column :census_1930_records, :attended_school, :boolean, using: "CASE WHEN 0 THEN 'f 'WHEN 1 THEN 't' ELSE NULL END"
    change_column :census_1930_records, :can_read_write, :boolean, using: "CASE WHEN 0 THEN 'f 'WHEN 1 THEN 't' ELSE NULL END"
    change_column :census_1930_records, :can_speak_english, :boolean, using: "CASE WHEN 0 THEN 'f 'WHEN 1 THEN 't' ELSE NULL END"
    change_column :census_1930_records, :worked_yesterday, :boolean, using: "CASE WHEN 0 THEN 'f 'WHEN 1 THEN 't' ELSE NULL END"
    change_column :census_1930_records, :veteran, :boolean, using: "CASE WHEN 0 THEN 'f 'WHEN 1 THEN 't' ELSE NULL END"
    change_column_default :census_1930_records, :foreign_born, nil
    change_column :census_1930_records, :foreign_born, :boolean, using: "CASE WHEN 0 THEN 'f 'WHEN 1 THEN 't' ELSE NULL END"
    change_column_default :census_1930_records, :foreign_born, false
  end
end
