class Person < ActiveRecord::Base
  has_one :census_1900_record, dependent: :nullify
  has_one :census_1910_record, dependent: :nullify
  has_one :census_1920_record, dependent: :nullify
  has_and_belongs_to_many :photos
  validates :first_name, :middle_name, :last_name, :sex, :race, presence: true
end
