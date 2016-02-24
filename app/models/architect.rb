class Architect < ActiveRecord::Base
  has_and_belongs_to_many :buildings
  validates :name, presence: true, length: { maximum: 255 }
end
