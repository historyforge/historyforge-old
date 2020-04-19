class PersonPresenter < Struct.new(:model, :user)

  def initialize(model, user)
    self.model, self.user = model, user
  end

  def name
    "#{last_name}, #{first_name} #{middle_name}".strip
  end

  def reviewed?
    true
  end

  def field_for(field)
    return public_send(field) if respond_to?(field)
    return model.public_send(field) if model.respond_to?(field)
    '?'
  end

  def method_missing(method, *args)
    model.public_send(method, *args)
  end

end
