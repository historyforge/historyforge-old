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

  class Builder
    def initialize(form)
      @form = form
      @cards = []
    end
    attr_accessor :form

    def start_card(title)
      @cards << Card.new(title)
    end

    def add_field(field, config)
      @cards.last << form.input(field, config).html_safe
    end

    def to_html
      @cards.map { |card| form.card(card.to_h).html_safe }.join().html_safe
    end
  end

  def render
    builder = Builder.new(form)
    fields.each do |field|
      config = field_config(field)
      if config[:as] == :divider
        builder.start_card(config[:label])
      else
        builder.add_field(field, config)
      end
    end
    builder.to_html
  end
end
