class Photograph < ApplicationRecord
  belongs_to :created_by, class_name: 'User'
  has_and_belongs_to_many :buildings
  has_and_belongs_to_many :people
  belongs_to :physical_type, optional: true
  belongs_to :physical_format, optional: true
  belongs_to :rights_statement, optional: true
  has_one_attached :file

  alias_attribute :caption, :description
end
