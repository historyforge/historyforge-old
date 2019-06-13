class AddIsVisibleFieldToLayers < ActiveRecord::Migration[4.2]
  def self.up
	add_column :layers, :is_visible, :boolean, :default => true
  end

  def self.down
	remove_column :layers, :is_visible
  end
end
