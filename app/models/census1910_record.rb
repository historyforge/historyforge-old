class Census1910Record < ActiveRecord::Base

  include AutoStripAttributes
  include CensusRecordConcern

  self.table_name = 'census_1910_records'

  # attribute :language_spoken, default: 'English'
  # attribute :unemployed_weeks_1909
  # attribute :civil_war_vet, as: :boolean
  # attribute :blind, as: :boolean
  # attribute :deaf_dumb, as: :boolean

  def self.define_enumeration(name, values, strict=false)
    class_eval "def self.#{name}_choices; #{values.inspect}; end"
    if strict
      validates_inclusion_of name, in: values
    end
  end

  auto_strip_attributes :county, :city, :state,
                        :street_prefix, :street_house_number, :street_name, :street_suffix,
                        :dwelling_number, :family_id, :last_name, :first_name, :middle_name,
                        :relation_to_head, :pob, :pob_father, :pob_mother,
                        :profession, :industry, :employment, :notes

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
end
