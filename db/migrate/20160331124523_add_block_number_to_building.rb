class AddBlockNumberToBuilding < ActiveRecord::Migration
  def change
    add_column :buildings, :block_number, :string, index: true
  end
end
