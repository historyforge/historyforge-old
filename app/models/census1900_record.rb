class Census1900Record < CensusRecord

  self.table_name = 'census_1900_records'

  validates :attended_school, :years_in_us, :years_married,
            :num_children_born, :num_children_alive, :unemployed_months,
            :birth_month, :birth_year, :age,
            numericality: { greater_than_or_equal_to: -1, allow_blank: true }

  validates :language_spoken, vocabulary: { name: :language, allow_blank: true }

  auto_strip_attributes :industry

  def year
    1900
  end

  def self.folder_name
    'census_records_nineteen_aught'
  end
end
