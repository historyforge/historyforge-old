class CensusRecord < ActiveRecord::Base

  self.abstract_class = true

  include JsonData
  include CensusRecordConcern

  before_validation :massage_page_number
  validates :page_no, presence: true

  attribute :notes
  attribute :page_number
  attribute :page_no, as: :integer
  attribute :page_side, as: :enumeration, values: %w{A B}, strict: true
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
  attribute :naturalized_alien, as: :enumeration, values: %w{na pa al}
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

  ransacker :street_address, formatter: proc { |v| v.mb_chars.downcase.to_s } do |parent|
    Arel::Nodes::NamedFunction.new('LOWER',
                                   [Arel::Nodes::NamedFunction.new('concat_ws',
                                                                   [Arel::Nodes::Quoted.new(' '),
                                                                     Arel::Nodes::InfixOperation.new("->>", parent.table[:data], Arel::Nodes::Quoted.new('street_house_number')),
                                                                     Arel::Nodes::InfixOperation.new("->>", parent.table[:data], Arel::Nodes::Quoted.new('street_prefix')),
                                                                     Arel::Nodes::InfixOperation.new("->>", parent.table[:data], Arel::Nodes::Quoted.new('street_name')),
                                                                     Arel::Nodes::InfixOperation.new("->>", parent.table[:data], Arel::Nodes::Quoted.new('street_suffix'))
                                                                     ])])
  end


  def massage_page_number
    if page_number.present? && page_no.blank?
      if page_number =~ /B|b/
        self.page_side = 'B'
      else
        self.page_side = 'A'
      end
      self.page_no = page_number.to_i
    end
  end


end
