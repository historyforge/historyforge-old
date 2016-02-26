class BuildingSerializer < ActiveModel::Serializer
  attributes :id, :name, :year_earliest, :year_latest, :description,
             :address, :city, :state, :postal_code, :building_type

  has_many :architects

  def building_type
    object.building_type.andand.name || 'unspecified'
  end
end
