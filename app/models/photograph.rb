class Photograph < ApplicationRecord
  belongs_to :created_by
  belongs_to :physical_type
  belongs_to :physical_format
  belongs_to :rights_statement
  has_one_attached :file
end
