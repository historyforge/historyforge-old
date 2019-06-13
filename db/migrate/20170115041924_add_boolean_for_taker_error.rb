class AddBooleanForTakerError < ActiveRecord::Migration[4.2]
  def change
    add_column :census_1910_records, :taker_error, :boolean, default: false
    Census1910Record.update_all taker_error: false
  end
end
