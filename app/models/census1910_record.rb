class Census1910Record < CensusRecord

  self.table_name = 'census_1910_records'

  attribute :years_married, as: :integer
  attribute :num_children_born, as: :integer
  attribute :num_children_alive, as: :integer
  attribute :pob, default: 'New York'
  attribute :pob_father, default: 'New York'
  attribute :pob_mother, default: 'New York'
  attribute :year_immigrated, as: :integer
  attribute :naturalized_alien
  attribute :language_spoken, default: 'English'
  attribute :profession
  attribute :industry
  attribute :employment, as: :enumeration, values: %w{W Emp OA}
  attribute :unemployed, as: :boolean
  attribute :unemployed_weeks_1909
  attribute :can_read, as: :boolean
  attribute :can_write, as: :boolean
  attribute :attended_school, as: :boolean
  attribute :owned_or_rented, as: :enumeration, values: %w{O R}
  attribute :mortgage, as: :enumeration, values: %w{M F}
  attribute :farm_or_house, as: :enumeration, values: %w{F H}
  attribute :num_farm_sched, as: :integer
  attribute :civil_war_vet, as: :boolean
  attribute :blind, as: :boolean
  attribute :deaf_dumb, as: :boolean

  # def self.model_name
  #   ActiveModel::Name.new(self, nil, "CensusRecord")
  # end

  def year
    1910
  end
end
