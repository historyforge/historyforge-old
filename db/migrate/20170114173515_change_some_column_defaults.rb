class ChangeSomeColumnDefaults < ActiveRecord::Migration
  def change
    change_column_default :census_1910_records, :blind, false
    change_column_default :census_1910_records, :deaf_dumb, false
  end
end
