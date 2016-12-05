class CensusRecordPresenter < Struct.new(:model, :user)

  def initialize(model, user)
    self.model, self.user = model, user
  end

  def name
    "#{last_name}, #{first_name} #{middle_name}".strip
  end

  def street_address
    [street_house_number, street_prefix, street_name, street_suffix].join(' ')
  end

  def method_missing(method, *args)
    model.send(method, *args)
  end

end
