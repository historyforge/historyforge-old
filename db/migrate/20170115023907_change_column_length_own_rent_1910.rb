class ChangeColumnLengthOwnRent1910 < ActiveRecord::Migration
  def change
    change_column :census_1910_records, :owned_or_rented, :string, limit: 10
  end
end
