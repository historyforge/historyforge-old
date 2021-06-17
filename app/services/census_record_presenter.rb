class CensusRecordPresenter < Struct.new(:model, :user)

  def initialize(model, user)
    self.model, self.user = model, user
  end

  def name
    "#{last_name}, #{first_name} #{middle_name}".strip
  end

  # def street_address
  #   [street_house_number, street_prefix, street_name, street_suffix].join(' ')
  # end

  def foreign_born
    model.foreign_born? ? 'Yes' : 'No'
  end

  def age
    if model.age_months
      if model.age.blank?
        "#{model.age_months}mo"
      else
        "#{model.age}y #{model.age_months}mo"
      end
    else
      model.age
    end
  end

  def race
    model.race && I18n.t("census_codes.race.#{model.race.downcase}", default: model.race) || 'left blank'
  end

  def marital_status
    model.marital_status && I18n.t("census_codes.marital_status.#{model.marital_status.downcase}", default: model.marital_status) || 'left blank'
  end

  def locality
    model.locality.name
  end

  %w{can_read can_write can_speak_english foreign_born unemployed attended_school
     blind deaf_dumb has_radio lives_on_farm can_read_write
     worked_yesterday veteran residence_1935_farm private_work public_work
     seeking_work had_job had_unearned_income veteran_dead soc_sec deductions multi_marriage
  }.each do |method|
    define_method method do
      yes_or_blank model.send(method)
    end
  end

  def census_scope
    "W #{model.ward} ED #{model.enum_dist} p. #{model.page_number}#{model.page_side} # #{model.line_number}"
  end

  def field_for(field)
    return public_send(field) if respond_to?(field)
    return model.public_send(field) if model.respond_to?(field)
    '?'
  end

  def yes_or_blank(value)
    value && 'Yes' || nil
  end

  def method_missing(method, *args)
    model.public_send(method, *args)
  end

end
