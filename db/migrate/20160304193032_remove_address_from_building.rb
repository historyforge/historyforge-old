class RemoveAddressFromBuilding < ActiveRecord::Migration
  def change
    remove_column :buildings, :address
  end
end
