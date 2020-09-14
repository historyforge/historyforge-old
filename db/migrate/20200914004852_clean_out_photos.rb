class CleanOutPhotos < ActiveRecord::Migration[6.0]
  def change
    drop_table :people_photos
    drop_table :buildings_photos
    drop_table :photos
  end
end
