class Building < ActiveRecord::Base

  include Moderation

  has_and_belongs_to_many :architects
  belongs_to :building_type
  belongs_to :frame_type, class_name: 'ConstructionMaterial'
  belongs_to :lining_type, class_name: 'ConstructionMaterial'
  has_many :census_records, dependent: :nullify

  has_many :photos, -> { order(:position) }, dependent: :destroy
  accepts_nested_attributes_for :photos, reject_if: :all_blank, allow_destroy: true

  validates :name, :address_street_name, :city, :state, presence: true, length: { maximum: 255 }
  validates :year_earliest, :year_latest, numericality: { minimum: 1500, maximum: 2100, allow_nil: true }

  delegate :name, to: :building_type, prefix: true, allow_nil: true

  scope :as_of_year, -> (year) { where("(year_earliest is null and year_latest is null) or (year_earliest<=:year and (year_latest is null or year_latest>=:year)) or (year_earliest is null and year_latest>=:year)", year: year)}

  def self.ransackable_scopes(auth_object=nil)
    %i{as_of_year}
  end

  geocoded_by :full_street_address, latitude: :lat, longitude: :lon
  after_validation :do_the_geocode, if: :new_record?

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

  def street_address
    [address_house_number, address_street_prefix, address_street_name, address_street_suffix].join(' ')
  end

  def neighbors
    lat? ? Building.near([lat, lon], 0.1).where('id<>?', id).limit(4) : []
  end

  def residents
    census_records
  end

  def families
    @families = if residents
      residents.group_by(&:dwelling_number)
    else
      nil
    end
  end

end
