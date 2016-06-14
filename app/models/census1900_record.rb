class Census1900Record < CensusRecord

  self.table_name = 'census_1900_records'

  attribute :birth_month, as: :integer
  attribute :birth_year, as: :integer
  attribute :years_in_us, as: :integer
  attribute :unemployed_months, as: :integer

  def year
    1900
  end

  def self.folder_name
    'census_records_nineteen_aught'
  end
end
