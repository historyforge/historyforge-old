class Census1920Record < CensusRecord

  self.table_name = 'census_1920_records'

  # attribute :year_naturalized, as: :integer
  # attribute :mother_tongue
  # attribute :mother_tongue_father
  # attribute :mother_tongue_mother
  # attribute :can_speak_english, as: :boolean

  auto_strip_attributes :industry, :employment, :pob, :mother_tongue,
                        :pob_father, :mother_tongue_father, :pob_mother, :mother_tongue_mother

  def year
    1920
  end

  def self.folder_name
    'census_records_nineteen_twenty'
  end

  define_enumeration :race, %w{W B M Ch Jp In Ot}

end
