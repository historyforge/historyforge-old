module Moderation
  extend ActiveSupport::Concern
  included do

    belongs_to :created_by, class_name: 'User'
    belongs_to :reviewed_by, class_name: 'User'

    def reviewed?
      reviewed_at.present?
    end

    scope :reviewed, -> { where "reviewed_at IS NOT NULL" }
    scope :recently_added, -> { where "created_at >= ?", 3.months.ago }
    scope :recently_reviewed, -> { where "reviewed_at >= ?", 3.months.ago }

  end
end
