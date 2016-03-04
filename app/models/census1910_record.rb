class Census1910Record < CensusRecord

  attribute :years_married, as: :integer
  attribute :num_children_born, as: :integer
  attribute :num_children_alive, as: :integer
  attribute :pob
  attribute :pob_father
  attribute :pob_mother
  attribute :year_immigrated, as: :integer
  attribute :naturalized_alien
  attribute :language_spoken
  attribute :profession
  attribute :industry
  attribute :employment
  attribute :unemployed, as: :boolean
  attribute :unemployed_weeks_1909
  attribute :can_read, as: :boolean
  attribute :can_write, as: :boolean
  attribute :attended_school, as: :boolean
  attribute :owned_or_rented
  attribute :mortgage
  attribute :farm_or_house
  attribute :num_farm_sched, as: :integer
  attribute :civil_war_vet, as: :boolean
  attribute :blind, as: :boolean
  attribute :deaf_dumb, as: :boolean

  def self.model_name
      ActiveModel::Name.new(self, nil, "CensusRecord")
    end
end
