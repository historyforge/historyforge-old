class CensusRecordPresenter < Struct.new(:model, :user)

  def initialize(model, user)
    self.model, self.user = model, user
  end

  delegate :method_missing, to: :model

  def name
    "#{last_name}, #{first_name} #{middle_name}".strip
  end

  def street_address
    [street_house_number, street_prefix, street_name, street_suffix].join(' ')
  end


end
