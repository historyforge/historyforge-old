class MyMap < ApplicationRecord
belongs_to :user
belongs_to :map
validates_uniqueness_of :user_id, :scope =>  :map_id, :message => "Map has already been saved."

end
