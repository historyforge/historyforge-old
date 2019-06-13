class AddMapTypeToMap < ActiveRecord::Migration[4.2]
  def self.up
    add_column :maps, :map_type, :integer, {:default => 1}
    #Map.update_all("map_type = 1")
  end

  def self.down
    remove_column :maps, :map_type
  end
end

