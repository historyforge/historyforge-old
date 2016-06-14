class CensusRecord < ActiveRecord::Base

  self.abstract_class = true

  include JsonData
  include Moderation
  belongs_to :building

  attr_accessor :ensure_building
  before_save :ensure_housing

  attribute :notes
  attribute :page_number
  attribute :line_number, as: :integer
  attribute :county, default: 'Tompkins'
  attribute :city, default: 'Ithaca'
  attribute :state, default: 'NY'
  attribute :ward
  attribute :enum_dist
  attribute :street_prefix, as: :enumeration, values: %w{N S E W}
  attribute :street_name
  attribute :street_suffix, as: :enumeration, values: %w{St Rd Ave Blvd Pl Terr Ct Pk Tr}.sort
  attribute :street_house_number
  attribute :dwelling_number
  attribute :family_id
  attribute :last_name
  attribute :first_name
  attribute :middle_name
  attribute :relation_to_head
  attribute :sex, as: :enumeration, values: %w{M F}
  attribute :race, as: :enumeration, values: %w{W B M}
  attribute :age
  attribute :marital_status, as: :enumeration, values: %w{S W D M1 M2 M3 M4 M5 M6}
  attribute :years_married, as: :integer
  attribute :num_children_born, as: :integer
  attribute :num_children_alive, as: :integer
  attribute :pob, default: 'New York'
  attribute :pob_father, default: 'New York'
  attribute :pob_mother, default: 'New York'
  attribute :year_immigrated, as: :integer
  attribute :naturalized_alien
  attribute :profession
  attribute :industry
  attribute :employment, as: :enumeration, values: %w{W Emp OA}
  attribute :unemployed, as: :boolean
  attribute :attended_school, as: :boolean
  attribute :can_read, as: :boolean
  attribute :can_write, as: :boolean
  attribute :can_speak_english, as: :boolean
  attribute :owned_or_rented, as: :enumeration, values: %w{O R}
  attribute :mortgage, as: :enumeration, values: %w{M F}
  attribute :farm_or_house, as: :enumeration, values: %w{F H}
  attribute :num_farm_sched, as: :integer

  ransacker :name, formatter: proc { |v| v.mb_chars.downcase.to_s } do |parent|
    Arel::Nodes::NamedFunction.new('LOWER',
                                   [Arel::Nodes::NamedFunction.new('concat_ws',
                                                                   [Arel::Nodes::Quoted.new(' '),
                                                                     Arel::Nodes::InfixOperation.new("->>", parent.table[:data], Arel::Nodes::Quoted.new('first_name')),
                                                                     Arel::Nodes::InfixOperation.new("->>", parent.table[:data], Arel::Nodes::Quoted.new('middle_name')),
                                                                     Arel::Nodes::InfixOperation.new("->>", parent.table[:data], Arel::Nodes::Quoted.new('last_name'))
                                                                     ])])
  end

  validates :first_name, :last_name, :family_id, :dwelling_number, :relation_to_head,
            :sex, :race, :age, :marital_status,
            :page_number, :line_number, :county, :city, :state, :ward, :enum_dist,
            presence: true

  validate :dont_add_same_person, on: :create
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
    [first_name, middle_name, last_name].select(&:present?).join(' ')
  end

  def street_address
    [street_house_number, street_prefix, street_name, street_suffix].join(' ')
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
    search_streets = street_name == 'Mill' ? ['Court', 'Mill'] : street_name
    @buildings_on_street ||= Building.where(address_street_name: search_streets, city: city).order(:address_house_number)
  end

  def matching_building(my_street_name = nil)
    my_street_name ||= street_name
    @matching_building ||= Building.where(address_house_number: street_house_number,
                                          address_street_prefix: street_prefix,
                                          address_street_name: my_street_name,
                                          city: city).first
  end

  def ensure_housing
    building_from_address if building_id.blank? && ensure_building == '1' && street_name.present? && city.present? && street_house_number.present?
  end

  def building_from_address
    my_street_name = street_name == 'Mill' ? 'Court' : street_name

    self.building ||= matching_building(my_street_name) || Building.create(
      name: "#{street_name} #{street_suffix} - #{street_prefix} - ##{street_house_number}",
      address_house_number: street_house_number,
      address_street_prefix: street_prefix,
      address_street_name: my_street_name,
      address_street_suffix: street_suffix,
      city: city,
      state: state,
      building_type: BuildingType.where(name: 'residence').first
    )
  end

  def year
    raise 'Need a year!'
  end

end
