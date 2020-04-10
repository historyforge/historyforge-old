class Person < ApplicationRecord
  include PersonNames
  has_one :census_1900_record, dependent: :nullify
  has_one :census_1910_record, dependent: :nullify
  has_one :census_1920_record, dependent: :nullify
  has_one :census_1930_record, dependent: :nullify
  has_and_belongs_to_many :photos
  validates :last_name, :sex, :race, presence: true
end
