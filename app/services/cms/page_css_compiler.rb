module Cms
  class PageCssCompiler

    def self.run(page)
      new(page).run
    end

    def initialize(page)
      @page = page
      @css_id = page.css_id.present? ? page.css_id : "page_#{page.id}"
      @css_class = page.css_class.present? ? page.css_class : "page_#{page.id}"
    end

    def run
      css = wrap(page.css) if page.css.present?
      if css.present?
        Sass::Engine.new(css,
                         :syntax => :scss,
                         :cache => false,
                         :read_cache => false,
                         :style => :compact).render

      else
        nil
      end
    rescue Sass::SyntaxError => e
      page.errors.add :base, e.message
      false
    end

    private

    attr_reader :page

    def wrap(css)
      "##{@css_id} {\n#{css}}\n"
    end
  end
end