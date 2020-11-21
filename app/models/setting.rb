class Setting < ApplicationRecord
  def self.value_of(key)
    setting = find_by(key: key)
    setting && setting.cast_value
  end

  def cast_value
    return nil if value.blank?

    if input_type == 'string'
      value
    elsif input_type == 'integer'
      value.to_i
    elsif input_type == 'number'
      value.to_f
    elsif input_type == 'boolean'
      value == '1'
    end
  end

  def self.add(key, type: 'string', value:, name: nil, group: 'General', hint: nil)
    setting = find_or_initialize_by key: key
    return if setting.persisted?

    setting.name = name || key.to_s.humanize.titleize
    setting.input_type = type
    setting.value = value.to_s
    setting.group = group
    setting.hint = hint
    setting.save
  end
end
