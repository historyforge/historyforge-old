class Census1900Record < CensusRecord

  self.table_name = 'census_1900_records'

  # attribute :birth_month, as: :integer
  # attribute :birth_year, as: :integer
  # attribute :years_in_us, as: :integer
  # attribute :unemployed_months, as: :integer

  validates :attended_school, :years_in_us, :years_married,
            :num_children_born, :num_children_alive, :unemployed_months,
            :birth_month, :birth_year, :age,
            numericality: { greater_than_or_equal_to: 0, allow_blank: true }

  auto_strip_attributes :industry, :pob, :pob_father, :pob_mother

  def year
    1900
  end

  def self.folder_name
    'census_records_nineteen_aught'
  end
end
