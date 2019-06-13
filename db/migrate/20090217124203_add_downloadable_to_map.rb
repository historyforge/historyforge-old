class AddDownloadableToMap < ActiveRecord::Migration[4.2]
  def self.up
    	add_column :maps, :downloadable,  :boolean, :default => true
  end

  def self.down
     remove_column :maps,  :downloadable
  end
end
