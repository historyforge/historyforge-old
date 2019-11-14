class Census1930Record < CensusRecord
  self.table_name = 'census_1930_records'

  define_enumeration :worker_class, %w{e w o np}
  define_enumeration :war_fought, %w{WW Sp Civ Phil Box Mex}
  define_enumeration :marital_status, %w{S W D M}
  define_enumeration :race, %w{W Neg Mex In Ch Jp Fil Hin Kor}
  define_enumeration :relation_to_head, %w{head wife son daughter lodger roomer boarder sister servant}
  define_enumeration :name_suffix, %w{jr sr}
  define_enumeration :name_prefix, %w{dr mr mrs}

  after_initialize :set_defaults

  def year
    1930
  end

  def set_defaults
    self.pob_code ||= 56
  end

  def self.folder_name
    'census_records_nineteen_thirty'
  end

end
