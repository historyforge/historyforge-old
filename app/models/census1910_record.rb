class Census1910Record < CensusRecord

  self.table_name = 'census_1910_records'

  validates :language_spoken, vocabulary: { name: :language, allow_blank: true }

  auto_strip_attributes :industry, :employment

  def year
    1910
  end

  def self.folder_name
    'census_records_nineteen_ten'
  end
end
