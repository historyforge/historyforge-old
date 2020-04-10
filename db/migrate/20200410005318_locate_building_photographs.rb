class LocateBuildingPhotographs < ActiveRecord::Migration[6.0]
  def change
    Photograph.find_each do |photo|
      building = photo.buildings&.first
      if building
        photo.latitude = building.latitude
        photo.longitude = building.longitude
        photo.save
      end
    end
  end
end
