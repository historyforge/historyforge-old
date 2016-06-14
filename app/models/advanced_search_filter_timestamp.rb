module AdvancedSearchFilterTimestamp
  def self.call(resource_class)
    filename = File.join(Rails.root, 'app', 'views', 'people', resource_class.folder_name, 'advanced_search_filters.json.jbuilder')
    File.mtime(filename).to_i
  end
end
