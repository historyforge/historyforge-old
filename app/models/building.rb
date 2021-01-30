class Building < ApplicationRecord

  include AutoStripAttributes
  include Moderation
  include DefineEnumeration
  include Flaggable

  define_enumeration :address_street_suffix, %w{St Rd Ave Blvd Pl Terr Ct Pk Tr Dr Hill Ln Way}.sort

  has_and_belongs_to_many :architects
  has_and_belongs_to_many :building_types, join_table: :buildings_building_types
  belongs_to :frame_type, class_name: 'ConstructionMaterial', optional: true
  belongs_to :lining_type, class_name: 'ConstructionMaterial', optional: true
  has_many :census_records, dependent: :nullify, class_name: 'Census1910Record'

  has_many :census_1900_records, dependent: :nullify, class_name: 'Census1900Record'
  has_many :census_1910_records, dependent: :nullify, class_name: 'Census1910Record'
  has_many :census_1920_records, dependent: :nullify, class_name: 'Census1920Record'
  has_many :census_1930_records, dependent: :nullify, class_name: 'Census1930Record'
  has_many :census_1940_records, dependent: :nullify, class_name: 'Census1940Record'

  has_and_belongs_to_many :photos, class_name: 'Photograph', dependent: :nullify

  validates :name, :address_street_name, :city, :state, presence: true, length: { maximum: 255 }
  validates :address_house_number, presence: true, if: :residence?
  validates :year_earliest, :year_latest, numericality: { minimum: 1500, maximum: 2100, allow_nil: true }

  delegate :name, to: :frame_type, prefix: true, allow_nil: true
  delegate :name, to: :lining_type, prefix: true, allow_nil: true

  scope :as_of_year, -> (year) { where("(year_earliest is null and year_latest is null) or (year_earliest<=:year and (year_latest is null or year_latest>=:year)) or (year_earliest is null and year_latest>=:year)", year: year)}
  scope :as_of_year_eq, -> (year) { where("(year_earliest<=:year and (year_latest is null or year_latest>=:year)) or (year_earliest is null and year_latest>=:year)", year: year)}
  scope :without_residents, -> {
    joins("LEFT OUTER JOIN census_1910_records ON census_1910_records.building_id=buildings.id")
      .joins(:building_types)
      .where("census_1910_records.id IS NULL")
      .where(building_types: { name: 'residence' }) }
  scope :by_street_address, -> { order("address_street_name asc, address_street_prefix asc, address_house_number asc") }

  def self.ransackable_scopes(auth_object=nil)
    %i{as_of_year without_residents as_of_year_eq}
  end

  has_paper_trail

  Geocoder.configure(
    timeout: 2,
    use_https: true,
    lookup: :google,
    api_key: AppConfig.geocoding_key
  )

  geocoded_by :full_street_address, latitude: :lat, longitude: :lon
  after_validation :do_the_geocode, if: :new_record?

  ransacker :street_address, formatter: proc { |v| v.mb_chars.downcase.to_s } do |parent|
    Arel::Nodes::NamedFunction.new('LOWER',
                                   [Arel::Nodes::NamedFunction.new('concat_ws',
                                                                   [Arel::Nodes::Quoted.new(' '),
                                                                     parent.table[:address_house_number],
                                                                     parent.table[:address_street_prefix],
                                                                     parent.table[:address_street_name],
                                                                     parent.table[:address_street_suffix]
                                                                     ])])
  end

  auto_strip_attributes :name, :city, :postal_code, :address_house_number,
                        :address_street_name,
                        :address_street_prefix, :address_house_number, :address_street_suffix,
                        :stories

  def field_for(field)
    respond_to?(field) ? public_send(field) : '?'
  end

  alias_attribute :latitude, :lat
  alias_attribute :longitude, :lon

  def has_proper_name?
    name && (address_house_number.blank? || !name.include?(address_house_number))
  end

  def residence?
    building_types.include?(BuildingType.find_by(name: 'residence'))
  end

  def full_street_address
    "#{[street_address, city, state].join(' ')} #{postal_code}"
  end

  def do_the_geocode
    begin
      geocode
    rescue Errno::ENETUNREACH
      nil
    end
  end

  def address_parts
    parts = [street_address].compact
    parts << [[city, state].join(", "), postal_code].join(' ')
  end

  def architects_list
    architects.map(&:name).join(', ')
  end

  def architects_list=(value)
    self.architects = value.split(',').map(&:strip).map {|item| Architect.where(name: item).first_or_create }
  end

  def building_type_name
    building_types.map(&:name).join('/')
  end

  def street_address
    [address_house_number, address_street_prefix, address_street_name, address_street_suffix].join(' ')
  end

  def neighbors
    lat? ? Building.near([lat, lon], 0.1).where('id<>?', id).limit(4) : []
  end

  attr_accessor :residents

  def with_filtered_residents(year, params)
    if year.present?
      people_class = "Census#{year}Record".constantize
      people = people_class.where.not(reviewed_at: nil)
      if params.present?
        params = JSON.parse(params) if params.is_a?(String)
        q = params.inject({}) {|hash, item|
          hash[item[0].to_sym] = item[1] if item[1].present?
          hash
        }
        @residents = people.where(building_id: id).ransack(q).result
      end
    end
  end

  def with_residents
    @residents = [1900, 1910, 1920, 1930, 1940].map { |year| send("census_#{year}_records").to_a }.flatten
    self
  end

  def families
    @families = if residents
      residents.group_by(&:dwelling_number)
    else
      nil
    end
  end

  def families_in_1900
    census_1900_records.group_by(&:dwelling_number)
  end
  def families_in_1910
    census_1910_records.group_by(&:dwelling_number)
  end
  def families_in_1920
    census_1920_records.group_by(&:dwelling_number)
  end
  def families_in_1930
    census_1930_records.group_by(&:dwelling_number)
  end
  def families_in_1940
    census_1940_records.group_by(&:family_id)
  end
end
