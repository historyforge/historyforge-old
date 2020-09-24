class AddBlockNumberToBuilding < ActiveRecord::Migration[4.2]
  def change
    add_column :buildings, :block_number, :string, index: true
  end
end
