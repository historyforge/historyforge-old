class ConstructionMaterial < ActiveRecord::Base
  validates :name, :color, presence: true
end
