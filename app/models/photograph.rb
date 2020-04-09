class Photograph < ApplicationRecord
  belongs_to :created_by, class_name: 'User'
  has_and_belongs_to_many :buildings
  has_and_belongs_to_many :people
  belongs_to :physical_type, optional: true
  belongs_to :physical_format, optional: true
  belongs_to :rights_statement, optional: true
  has_one_attached :file

  alias_attribute :caption, :description

  attr_writer :date_year, :date_month, :date_day
  attr_writer :date_year_end, :date_month_end, :date_day_end

  enum date_type: %i[year month day years months days]

  before_validation :set_dates

  def full_caption
    items = [caption]
    items << date_text if date_text?
    items.compact.join(' ')
  end

  def date_year
    date_start&.year
  end

  def date_month
    date_start&.month
  end

  def date_day
    date_start&.day
  end

  def date_year_end
    date_end&.year
  end

  def date_month_end
    date_end&.month
  end

  def date_day_end
    date_end&.day
  end

  def set_dates
    self.date_start = nil
    self.date_end = nil
    if year? || years?
      self.date_start = Date.parse("#{date_year}-01-01") if date_year
      self.date_end = Date.parse("#{date_year}-12-31") if years? && date_year_end
    end
    if month? || months?
      self.date_start = Date.parse("#{date_year}-#{date_month.ljust(2, '0')}-01") if date_year && date_month
      self.date_end = Date.parse("#{date_year_end}-#{date_month_end.ljust(2, '0')}-01").end_of_month if months? && date_year_end && date_month_end
    end
    if day? || days?
      self.date_start = Date.parse("#{date_year}-#{date_month.ljust(2, '0')}-#{date_day.ljust(2, '0')}") if date_year && date_month && date_day
      self.date_end = Date.parse("#{date_year_end}-#{date_month_end.ljust(2, '0')}-#{date_day_end.ljust(2, '0')}") if days? && date_year_end && date_month_end && date_day_end
    end
  end
end
