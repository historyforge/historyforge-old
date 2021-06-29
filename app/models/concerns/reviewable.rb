module Reviewable
  extend ActiveSupport::Concern

  included do
    belongs_to :reviewed_by, class_name: 'User', optional: true
    scope :reviewed, -> { where.not(reviewed_at: nil) }
    scope :unreviewed, -> { where(reviewed_at: nil) }
  end

  def review!(reviewer)
    return if reviewed?
    self.reviewed_at = Time.now
    self.reviewed_by = reviewer
    unless save
      self.reviewed_at = nil
      self.reviewed_by = nil
    end
    self
  end

  def prepare_for_review
    return if reviewed?
    self.reviewed_at = Time.now
    validate
    self.reviewed_at = nil
  end

  def reviewed?
    reviewed_at.present?
  end
end
