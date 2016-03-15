class BuildingSerializer < ActiveModel::Serializer

  attributes :id, :name, :year_earliest, :year_latest, :description,
             :street_address, :city, :state, :postal_code, :building_type,
             :latitude, :longitude, :photo

  has_many :architects, serializer: ArchitectSerializer
  has_many :photos, serializer: PhotoSerializer
  has_many :census_records, serializer: CensusRecordSerializer

  def photo
    object.photos.andand.first.andand.id
  end

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
