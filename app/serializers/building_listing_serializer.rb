class BuildingListingSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :name, :year_earliest, :year_latest,
             :street_address, :city, :state, :postal_code, :building_type_id,
             :latitude, :longitude

  # has_many :architects, serializer: ArchitectSerializer

  attribute :residents do |object|
    object.residents.present? && object
        .residents
        .map { |item| CensusRecordSerializer.new(item).as_json }
        .group_by { |item| item['data']['attributes']['year'] }
  end
end
