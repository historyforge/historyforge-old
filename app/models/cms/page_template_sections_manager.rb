class Cms::PageTemplateSectionsManager
  attr_reader :page
  def initialize(page)
    @page = page
  end
  def all_template_sections
    @all_template_sections ||= page.widgets.inject({}) {|hash, item|
      hash[item.name] = item
      hash
    }
  end

  def sections
    tokens = []
    items = []
    page.template_sections ||= []
    page.template_sections.each do |token|
      if all_template_sections.key?(token)
        tokens << token
        items << all_template_sections[token]
      end
    end
    all_template_sections.each {|token, item|
      unless page.template_sections.include?(token)
        tokens << token
        items << item
      end
    }
    page.template_sections = tokens
    items
  end

  def render
    page.template = sections && page.template_sections.map {|section| "{{#{section}}}"}.join("\n")
  end

end
