class Census1910Record < CensusRecord

  self.table_name = 'census_1910_records'

  attribute :language_spoken, default: 'English'
  attribute :unemployed_weeks_1909
  attribute :civil_war_vet, as: :boolean
  attribute :blind, as: :boolean
  attribute :deaf_dumb, as: :boolean

  def year
    1910
  end
end
