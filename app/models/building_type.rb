class BuildingType < ActiveRecord::Base
  has_many :buildings, dependent: :nullify
  validates :name, presence: true, length: { maximum: 255 }
  RESIDENCE = 3
end
