class CensusFormFields
  class_attribute :inputs, :fields
  attr_accessor :inputs, :fields, :form

  def self.input(field, **options)
    self.fields ||= []
    self.inputs ||= {}
    fields << field
    inputs[field] = options
  end

  def initialize(form)
    @fields = self.class.fields.dup
    @inputs = self.class.inputs.dup
    @form = form
  end

  def render_field(field)
    form.input(field, field_config(field)).html_safe
  end

  def field_config(field)
    options = inputs[field]
    if options[:hint] && options[:hint].respond_to?(:call)
      options[:hint] = form.template.instance_exec &options[:hint]
    end
    options
  rescue Exception => error
    Rails.logger.error "*** Field Config Missing for #{field}! ***"
    raise error
  end

  def render
    fields.map { |field| render_field(field) }.join("\n").html_safe
  end
end
