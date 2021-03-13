module PersonNames
  extend ActiveSupport::Concern
  included do
    before_validation :capitalize_name, on: :create
    before_validation :clean_middle_name
    before_save :set_searchable_name

    scope :fuzzy_name_search, -> (name) {
      where("searchable_name % ?", name)
    }

    def set_searchable_name
      self.searchable_name = name
    end

    def name
      [name_prefix, first_name, middle_name, last_name, name_suffix].select(&:present?).join(' ')
    end

    private

    def capitalize_name
      self.first_name = CapitalizeNames.capitalize(first_name) if first_name.present?
      self.last_name = CapitalizeNames.capitalize(last_name) if last_name.present?
    end

    def clean_middle_name
      return if middle_name.blank?
      self.middle_name = middle_name.gsub(/\W/, ' ').strip.squish
    end
  end
end