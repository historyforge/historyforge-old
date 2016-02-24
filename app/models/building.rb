class Building < ActiveRecord::Base
  has_and_belongs_to_many :architects
  belongs_to :building_type
  validates :name, :address, :city, :state, presence: true, length: { maximum: 255 }
  validates :year_earliest, :year_latest, numericality: { minimum: 1500, maximum: 2100, allow_nil: true }
end
