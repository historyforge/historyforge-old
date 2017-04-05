class Census1910Record < ActiveRecord::Base

  include AutoStripAttributes
  extend  EnumerationAttributes
  include CensusRecordConcern

  self.table_name = 'census_1910_records'

  # attribute :language_spoken, default: 'English'
  # attribute :unemployed_weeks_1909
  # attribute :civil_war_vet, as: :boolean
  # attribute :blind, as: :boolean
  # attribute :deaf_dumb, as: :boolean

  auto_strip_attributes :county, :city, :state,
                        :street_prefix, :street_house_number, :street_name, :street_suffix,
                        :dwelling_number, :family_id, :last_name, :first_name, :middle_name,
                        :relation_to_head, :pob, :pob_father, :pob_mother,
                        :profession, :industry, :employment, :notes

  before_validation  :set_profession_to_none_if_blank
  validate           :validate_employment_status, unless: :taker_error?
  validate           :validate_head_of_household, unless: :taker_error?

  define_enumeration :page_side, %w{A B}, true
  define_enumeration :street_prefix, %w{N S E W}
  define_enumeration :street_suffix, %w{St Rd Ave Blvd Pl Terr Ct Pk Tr}.sort
  define_enumeration :sex, %w{M F}
  define_enumeration :race, %w{W B M}
  define_enumeration :marital_status, %w{S W D M1 M2 M3 M4 M5 M6}
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
                                                                     parent.table[:first_name],
                                                                     parent.table[:middle_name],
                                                                     parent.table[:last_name]
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

  def year
    1910
  end

  def self.folder_name
    'census_records_nineteen_ten'
  end

  def set_profession_to_none_if_blank
    self.profession = 'None' if profession.blank?
  end

  def validate_employment_status
    if employment == 'W'
      errors.add(:unemployed, "Required since Employment is W.") if unemployed.nil?
      errors.add(:unemployed_weeks_1909, "Required since Employment is W.") if unemployed_weeks_1909.blank?
    end
  end
  def validate_head_of_household
    if relation_to_head == 'Head'
      errors.add(:owned_or_rented, "Required for head of household") if owned_or_rented.blank?
      errors.add(:owned_or_rented, "Head of household either owns or rents.") if owned_or_rented == 'Neither'
      errors.add(:mortgage, "Must be M or F for head of household.") if owned_or_rented == 'O' && mortgage.blank?
      errors.add(:farm_or_house, "Must be F or H for head of household.") if owned_or_rented == 'O' && farm_or_house.blank?
    end
  end

end
