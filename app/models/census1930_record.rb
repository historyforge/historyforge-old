class Census1930Record < CensusRecord
  self.table_name = 'census_1930_records'

  def year
    1930
  end

  def self.folder_name
    'census_records_nineteen_thirty'
  end
end
