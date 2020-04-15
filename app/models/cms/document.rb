class Cms::Document < Cms::PageWidget

  has_one_attached :file
  delegate :url, :current_path, :content_type, :filename, :to => :file

  json_attribute :title, as: :string
  json_attribute :description, as: :string

  before_save :cache_html

  def render
    DocumentRenderer.new(self).render
  end

  class DocumentRenderer
    include ActionView::Helpers::TagHelper
    attr_reader :document
    def initialize(document)
      @document = document
    end
    def render
      # link with title
      html = content_tag :a, document.title, {
        href: document.url,
        target: '_blank'
      }
      # description
      html << content_tag(:p, document.description, class: 'caption') if document.description?

      # put them together
      html_options = { class: 'cms-slide cms-document ' }
      html_options[:class] << document.css_class if document.css_class?
      html_options[:id] = document.css_id if document.css_id?
      if document.css_clear.present? && document.css_clear != 'none'
        html_options[:style] = "clear: #{document.css_clear};"
      end

      content_tag :div, html, html_options
    end
  end
end
