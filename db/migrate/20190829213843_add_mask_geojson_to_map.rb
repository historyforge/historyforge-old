class AddMaskGeojsonToMap < ActiveRecord::Migration[4.2]
  def change
    add_column :maps, :mask_geojson, :text
  end
end