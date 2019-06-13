class AddIdToLayersMaps < ActiveRecord::Migration[4.2]
  def self.up
    add_column :layers_maps, :id, :primary_key
  end

  def self.down
     remove_column :layers_maps, :id
  end
end
