class Term < ApplicationRecord
  belongs_to :vocabulary
  validates :name, presence: true
end
