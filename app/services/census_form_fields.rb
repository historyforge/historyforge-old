class CensusFormFields
  class_attribute :inputs, :fields
  attr_accessor :inputs, :fields, :form

  def self.input(field, **options)
    self.fields ||= []
    self.inputs ||= {}
    fields << field
    inputs[field] = options
  end

  def self.divider(title)
    self.fields ||= []
    self.inputs ||= {}
    fields << title
    inputs[title] = { as: :divider, label: title }
  end

  def initialize(form)
    @fields = self.class.fields.dup
    @inputs = self.class.inputs.dup
    @form = form
  end

  def render_field(field, config=nil)
    config ||= field_config(field)
    output = form.input(field, config)
    output ? output.html_safe : ''
  end

  def field_config(field)
    options = inputs[field]
    if options[:hint] && options[:hint].respond_to?(:call)
      options[:hint] = form.template.instance_exec &options[:hint]
    end
    options
  rescue StandardError => error
    Rails.logger.error "*** Field Config Missing for #{field}! ***"
    raise error
  end

  class Card
    def initialize(title)
      @title = title
      @list = []
    end
    attr_accessor :title, :list

    def to_h
      { title: title, list: list }
    end

    def <<(item)
      list << item
    end
  end

  def render
    html = ''
    card = nil
    fields.each do |field|
      config = field_config(field)
      if config[:as] == :divider
        if card
          html << form.card(card.to_h)
          card = nil
          next
        end
        card = Card.new config[:label]
      elsif card
        card << render_field(field, config)
      end
    end
    html << form.card(card.to_h) if card
    html.html_safe
  end
end
