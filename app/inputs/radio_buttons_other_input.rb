class RadioButtonsOtherInput < CollectionRadioButtonsInput

  def input(wrapper_options=nil)
    fields = super
    fields.sub('{{OTHER}}', other_input.html_safe).html_safe
  end

  def with_extra_items(items)
    keys = items.map(&:last)
    items = add_blanks(items) unless keys.include?(nil)
    items << ['{{OTHER}}', (keys.include?(value) || value.blank? ? 'other' : value)]
    items
  end

  def other_input
    items = options[:original_collection].first.is_a?(String) ? options[:original_collection] : options[:original_collection].map(&:last)
    other_value = value.blank? || items.include?(value) ? nil : value
    Rails.logger.info attribute_name.inspect
    Rails.logger.info value.inspect
    Rails.logger.info items.inspect
    Rails.logger.info items.include?(value).inspect
    Rails.logger.info other_value.inspect
    "Other: <input type=\"text\" value=\"#{other_value}\" data-type=\"other-radio-button\">"
  end
end