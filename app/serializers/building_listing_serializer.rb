class BuildingListingSerializer < ActiveModel::Serializer
  attributes :id, :name, :year_earliest, :year_latest,
             :street_address, :city, :state, :postal_code, :building_type_id,
             :latitude, :longitude

  # has_many :architects, serializer: ArchitectSerializer

  def building_type
    object.building_type.andand.name || 'unspecified'
  end

  def latitude
    object.lat
  end

  def longitude
    object.lon
  end
end
