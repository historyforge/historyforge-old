class PeopleAndPhotos < ActiveRecord::Migration
  def change
    create_table :buildings_photos, id: false do |t|
      t.references :building, foreign_key: true
      t.references :photo, foreign_key: true
    end
    create_table :people_photos, id: false do |t|
      t.references :person, foreign_key: true
      t.references :photo, foreign_key: true
    end
    if table_exists?(:buildings_photos)
      Photo.where.not(building_id: nil).each do |photo|
        building = Building.find photo.building_id
        photo.buildings << building
      end
    end
  end
end
