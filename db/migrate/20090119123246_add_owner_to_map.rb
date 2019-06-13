class AddOwnerToMap < ActiveRecord::Migration[4.2]
  def self.up
    add_column :maps, :owner_id, :integer
  end

  def self.down
    remove_column :maps, :owner_id
  end
end
