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

  def render_field(field)
    config = field_config(field)
    if config[:as] == :divider
      "<h3>#{config[:label]}</h3>".html_safe
    else
      output = form.input(field, config)
      output ? output.html_safe : ''
    end
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

  def render
    fields.map { |field| render_field(field) }.join("\n").html_safe
  end
end
