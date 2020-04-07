class Census1930Record < CensusRecord
  self.table_name = 'census_1930_records'

  validates :mother_tongue, vocabulary: { name: :language, allow_blank: true }

  define_enumeration :worker_class, %w{E W OA NP}
  define_enumeration :war_fought, %w{WW Sp Civ Phil Box Mex}
  define_enumeration :marital_status, %w{S W D M}
  define_enumeration :race, %w{W Neg Mex In Ch Jp Fil Hin Kor}
  define_enumeration :relation_to_head, %w{Head Wife Son Daughter Lodger Roomer Boarder Sister Servant}
  define_enumeration :name_suffix, %w{Jr Sr}
  define_enumeration :name_prefix, %w{Dr Mr Mrs}

  # after_initialize :set_defaults
  auto_strip_attributes :industry, :profession_code, :pob, :pob_mother, :pob_father, :pob_code, :mother_tongue, :worker_class

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
