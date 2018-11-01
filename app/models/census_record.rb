class CensusRecord < ApplicationRecord

  self.abstract_class = true

  include DefineEnumeration
  include Moderation

  belongs_to :building
  belongs_to :person

  attr_accessor :ensure_building
  before_save :ensure_housing

  validates :first_name, :last_name, :family_id, :dwelling_number, :relation_to_head,
            :sex, :race, :age, :marital_status,
            :page_number, :page_side, :line_number, :county, :city, :state, :ward, :enum_dist,
            presence: true

  validate :dont_add_same_person, on: :create

  define_enumeration :page_side, %w{A B}, true
  define_enumeration :street_prefix, %w{N S E W}
  define_enumeration :street_suffix, %w{St Rd Ave Blvd Pl Terr Ct Pk Tr Dr Hill Ln Way}.sort
  define_enumeration :sex, %w{M F}
  define_enumeration :race, %w{W B M}
  define_enumeration :marital_status, %w{S W D M M1 M2 M3 M4 M5 M6}
  define_enumeration :naturalized_alien, %w{na pa al}
  define_enumeration :employment, %w{W Emp OA}
  define_enumeration :owned_or_rented, %w{O R Neither}
  define_enumeration :mortgage, %w{M F}
  define_enumeration :farm_or_house, %w{F H}
  define_enumeration :civil_war_vet, %w{UA UN CA CN}

  ransacker :name, formatter: proc { |v| v.mb_chars.downcase.to_s } do |parent|
    Arel::Nodes::NamedFunction.new('LOWER',
                                   [Arel::Nodes::NamedFunction.new('concat_ws',
                                                                   [Arel::Nodes::Quoted.new(' '),
                                                                     parent.table[:name_prefix],
                                                                     parent.table[:first_name],
                                                                     parent.table[:middle_name],
                                                                     parent.table[:last_name],
                                                                     parent.table[:name_suffix]
                                                                     ])])
  end

  ransacker :street_address, formatter: proc { |v| v.mb_chars.downcase.to_s } do |parent|
    Arel::Nodes::NamedFunction.new('LOWER',
                                   [Arel::Nodes::NamedFunction.new('concat_ws',
                                                                   [Arel::Nodes::Quoted.new(' '),
                                                                     parent.table[:street_house_number],
                                                                     parent.table[:street_prefix],
                                                                     parent.table[:street_name],
                                                                     parent.table[:street_suffix]
                                                                     ])])
  end

  def field_for(field)
    respond_to?(field) ? public_send(field) : '?'
  end

  def dont_add_same_person
    if new_record? && likely_matches?
      errors.add :last_name, 'A person with the same street number, street name, last name, and first name is already in the system.'
    end
  end

  def likely_matches?
    self.class.ransack(
      street_house_number_eq: street_house_number,
      street_name_eq: street_name,
      last_name_eq: last_name,
      first_name_eq: first_name,
      age_eq: age
    ).result.count > 0
  end

  def name
    [name_prefix, first_name, middle_name, last_name, name_suffix].select(&:present?).join(' ')
  end

  def street_address
    [street_house_number, street_prefix, street_name, street_suffix].join(' ')
  end

  def latitude
    building.andand.lat
  end

  def longitude
    building.andand.lon
  end

  def fellows
    @fellows ||= self.class.where('id<>?', id)
                     .ransack(street_house_number_eq: street_house_number,
                              street_prefix_eq: street_prefix,
                              street_name_eq: street_name,
                              dwelling_number_eq: dwelling_number,
                              family_id_eq: family_id).result
  end

  def buildings_on_street
    return [] unless (street_name.present? && city.present?)
    search_streets = [street_name, convert_street_name]
    @buildings_on_street ||= Building.where(address_street_name: search_streets, city: city).order(:address_house_number)
  end

  def matching_building(my_street_name = nil)
    my_street_name ||= convert_street_name
    my_street_prefix = convert_street_prefix
    @matching_building ||= Building.where(address_house_number: street_house_number,
                                          address_street_prefix: my_street_prefix,
                                          address_street_name: my_street_name,
                                          city: city).first
  end

  def ensure_housing
    building_from_address if building_id.blank? && ensure_building == '1' && street_name.present? && city.present? && street_house_number.present?
  end

  # TODO: street name conversions need to be backed by database, moved into own class
  def convert_street_name
    if street_name == 'Mill'
      'Court'
    elsif street_name == 'Railroad' || street_name == 'Neahga'
      'Lincoln'
    elsif street_name == 'Boulevard' || street_name == 'Glenwood'
      'Old Taughannock'
    elsif street_name == 'Humboldt'
      'Floral'
    elsif street_name == 'Mechanic'
      'Hillview'
    elsif street_name == 'Tioga' && street_prefix == 'S'
      'Turner'
    elsif street_name == 'Wheat'
      'Cleveland'
    else
      street_name
    end
  end

  def convert_street_suffix
    if street_name == 'Railroad'
      'Ave'
    elsif street_name == 'Boulevard' || street_name == 'Glenwood'
      'Blvd'
    elsif street_name == 'Mechanic' || (street_name == 'Tioga' && street_prefix == 'S')
      'Pl'
    elsif street_name == 'Humboldt' || street_name == 'Wheat'
      'Avenue'
    else
      street_suffix
    end
  end

  def convert_street_prefix
    if street_name == 'Tioga' || street_prefix == 'S'
      nil
    else
      street_prefix
    end
  end

  def building_from_address
    my_street_name = convert_street_name
    my_street_suffix = convert_street_suffix
    my_street_prefix = convert_street_prefix
    self.building ||= matching_building(my_street_name) || Building.create(
      name: "#{street_name} #{street_suffix} - #{street_prefix} - ##{street_house_number}",
      address_house_number: street_house_number,
      address_street_prefix: my_street_prefix,
      address_street_name: my_street_name,
      address_street_suffix: my_street_suffix,
      city: city,
      state: state,
      building_type: BuildingType.where(name: 'residence').first
    )
  end

  def year
    raise 'Need a year!'
  end

  def generate_person_record!
    build_person
    person.first_name = first_name
    person.middle_name = middle_name
    person.last_name = last_name
    person.sex = sex
    person.race = race
    person.save
  end
end
