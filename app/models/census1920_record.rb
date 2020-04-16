class Census1920Record < CensusRecord

  self.table_name = 'census_1920_records'

  validates :mother_tongue, :mother_tongue_father, :mother_tongue_mother, vocabulary: { name: :language, allow_blank: true }

  define_enumeration :employment, %w{W Em OA}

  auto_strip_attributes :industry, :employment, :employment_code

  def year
    1920
  end

  def self.folder_name
    'census_records_nineteen_twenty'
  end

  define_enumeration :race, %w{W B Mu In Ch Jp Fil Hin Kor Ot}
  define_enumeration :marital_status, %w{S W D M}

  def can_add_buildings?
    false
  end
end
