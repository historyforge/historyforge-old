class CensusRecord < ActiveRecord::Base

  include JsonData
  belongs_to :building

  before_save :ensure_housing

  attribute :notes
  attribute :page_number
  attribute :line_number, as: :integer
  attribute :county, default: 'Tompkins'
  attribute :city, default: 'Ithaca'
  attribute  :state, default: 'NY'
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
  attribute :relation_to_head
  attribute :sex, as: :enumeration, values: %w{M F}
  attribute :race, as: :enumeration, values: %w{W B M}
  attribute :age
  attribute :marital_status, as: :enumeration, values: %w{S W D M1 M2 M3 M4 M5 M6}

  def name
    [first_name, last_name].join(' ')
  end

  def street_address
    [street_house_number, street_prefix, street_name, street_suffix].join(' ')
  end

  def fellows
    @fellows ||= CensusRecord.where('id<>?', id)
                     .ransack(street_house_number_eq: street_house_number,
                              street_prefix_eq: street_prefix,
                              street_name_eq: street_name,
                              dwelling_number_eq: dwelling_number,
                              family_id_eq: family_id).result
  end

  def matching_building
    @matching_building ||= Building.where(address_house_number: street_house_number,
                                          address_street_prefix: street_prefix,
                                          address_street_name: street_name,
                                          city: city).first
  end

  def ensure_housing
    self.building ||= matching_building || Building.create(
      name: "#{street_name} #{street_suffix} - #{street_prefix} - ##{street_house_number}",
      address_house_number: street_house_number,
      address_street_prefix: street_prefix,
      address_street_name: street_name,
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
