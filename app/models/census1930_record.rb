class Census1930Record < CensusRecord
  self.table_name = 'census_1930_records'

  define_enumeration :what_war, %w{WW Sp Civ Phil Box Mex Other}


  def year
    1930
  end

  def self.folder_name
    'census_records_nineteen_thirty'
  end
end
