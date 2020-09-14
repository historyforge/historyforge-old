class BuildingListingSerializer
  include FastJsonapi::ObjectSerializer

  cache_options enabled: true

  attributes :id, :year_earliest, :year_latest,
             :street_address, :city, :state, :postal_code,  :building_type_ids,
             :latitude, :longitude

  attribute :name do |object|
    object.has_proper_name? ? object.name : object.street_address
  end

  # has_many :architects, serializer: ArchitectSerializer

  # attribute :residents do |object|
  #   object.residents.present? && object
  #       .residents
  #       .map { |item| CensusRecordSerializer.new(item).as_json }
  #       .group_by { |item| item['data']['attributes']['year'] }
  # end
end
