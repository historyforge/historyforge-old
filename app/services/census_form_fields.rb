class CensusFormFields
  class_attribute :inputs, :fields

  def self.input(field, **options)
    self.fields ||= []
    self.inputs ||= {}
    fields << field
    inputs[field] = options
  end

  def self.render_field(field, form)
    form.input(field, field_config(field, form)).html_safe
  end

  def self.field_config(field, form)
    options = inputs[field]
    if options[:hint] && options[:hint].respond_to?(:call)
      options[:hint] = form.template.instance_exec &options[:hint]
    end
    options
  end

  def self.render(form)
    fields.map { |field| render_field(field, form) }.join("\n").html_safe
  end
end
