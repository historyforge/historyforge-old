module PersonNames
  extend ActiveSupport::Concern
  included do
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
  end
end