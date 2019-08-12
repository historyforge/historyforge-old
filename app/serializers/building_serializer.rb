class BuildingSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :name, :year_earliest, :year_latest, :description,
             :street_address, :city, :state, :postal_code, :building_type_id,
             :latitude, :longitude

  has_many :architects, serializer: ArchitectSerializer
  has_many :photos, serializer: PhotoSerializer

  # has_many :census_records #, serializer: CensusRecordSerializer

  attribute :photo do |object|
    object.photos.andand.first.andand.id
  end

  attribute :latitude do |object|
    object.lat
  end

  attribute :longitude do |object|
    object.lon
  end

  attribute :census_records do |object|
    if object.residents
      object
        .residents
        .map { |item| CensusRecordSerializer.new(item, root: false).as_json }
        .group_by { |item| item['year'] }
    else
      {
        1900 => object.census_1900_records.andand.map { |item| CensusRecordSerializer.new(item, root: false).as_json },
        1910 => object.census_1910_records.andand.map { |item| CensusRecordSerializer.new(item, root: false).as_json },
        1920 => object.census_1920_records.andand.map { |item| CensusRecordSerializer.new(item, root: false).as_json },
        1930 => object.census_1930_records.andand.map { |item| CensusRecordSerializer.new(item, root: false).as_json }
      }
    end
  end
end
