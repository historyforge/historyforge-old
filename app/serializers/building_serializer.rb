class BuildingSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :name, :year_earliest, :year_latest, :description,
             :street_address, :city, :state, :postal_code, :building_type_id

  has_many :architects, serializer: ArchitectSerializer
  has_many :photos, serializer: PhotoSerializer

  attribute :photo do |object|
    object.photos.andand.first.andand.id
  end

  attribute :latitude do |object|
    object.lat
  end

  attribute :longitude do |object|
    object.lon
  end

  attribute :census_records do |object, params|
    # if params[:condensed]
    #   nil
    # if object.residents
    #   object
    #     .residents
    #     .group_by(&:year)
    #     .map { |item| CensusRecordSerializer.new(item).as_json }
    # else
      {
        1900 => object.census_1900_records.andand.map { |item| CensusRecordSerializer.new(item).as_json['data']['attributes'] },
        1910 => object.census_1910_records.andand.map { |item| CensusRecordSerializer.new(item).as_json['data']['attributes'] },
        1920 => object.census_1920_records.andand.map { |item| CensusRecordSerializer.new(item).as_json['data']['attributes'] },
        1930 => object.census_1930_records.andand.map { |item| CensusRecordSerializer.new(item).as_json['data']['attributes'] }
      }
    # end
  end
end
