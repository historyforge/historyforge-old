class RemoveAddressFromBuilding < ActiveRecord::Migration[4.2]
  def change
    remove_column :buildings, :address
  end
end
