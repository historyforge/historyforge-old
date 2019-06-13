class AddFieldsToGcpsForRoughPlacingSteps < ActiveRecord::Migration[4.2]
  def self.up
    add_column :gcps, :soft, :boolean, :default => false
    add_column :gcps, :name, :string
    add_index :gcps, :soft
  end

  def self.down
    remove_index :gcps, :soft
    remove_column :gcps, :soft
    remove_column :gcps, :name
  end
end
