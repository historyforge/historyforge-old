class Census1940Record < CensusRecord
  self.table_name = 'census_1940_records'

  define_enumeration :worker_class, %w{PW GW E OA NP}
  define_enumeration :marital_status, %w{S W D M}
  define_enumeration :race, %w{W Neg In Ch Jp Fil Hin Kor}
  define_enumeration :name_suffix, %w{Jr Sr}
  define_enumeration :name_prefix, %w{Dr Mr Mrs}
  define_enumeration :grade_completed, %w{0 1 2 3 4 5 6 7 8 H-1 H-2 H-3 H-4 C-1 C-2 C-3 C-4 C-5}
  define_enumeration :naturalized_alien, %w{Na Pa Al AmCit}
  define_enumeration :war_fought, %w{W S SW R Ot}

  auto_strip_attributes :industry, :profession_code, :pob_code, :worker_class

  def year
    1940
  end

  def self.folder_name
    'census_records_nineteen_forty'
  end

  def supplemental?
    [15, 49].include?(line_number)
  end
end
