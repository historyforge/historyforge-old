class Census1910Record < CensusRecord

  self.table_name = 'census_1910_records'

  # attribute :language_spoken, default: 'English'
  # attribute :unemployed_weeks_1909
  # attribute :civil_war_vet, as: :boolean
  # attribute :blind, as: :boolean
  # attribute :deaf_dumb, as: :boolean

  auto_strip_attributes :industry, :employment, :pob, :pob_father, :pob_mother

  def year
    1910
  end

  def self.folder_name
    'census_records_nineteen_ten'
  end
end
