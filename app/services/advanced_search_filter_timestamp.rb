module AdvancedSearchFilterTimestamp
  def self.call(resource_class)
    if resource_class.respond_to?(:folder_name)
      filename = File.join(Rails.root, 'app', 'views', 'people', resource_class.folder_name, 'advanced_search_filters.json.jbuilder')
    else
      filename = File.join(Rails.root, 'app', 'views', resource_class.downcase.pluralize, 'advanced_search_filters.json.jbuilder')
    end
    File.mtime(filename).to_i
  end
end
