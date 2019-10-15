class MoreMapwarperCleaning < ActiveRecord::Migration[5.2]
  def change
    drop_table :layers_maps
    drop_table :layers
  end
end
