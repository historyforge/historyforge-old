class RadioButtonsOtherInput < CollectionRadioButtonsInput

  def input(wrapper_options=nil)
    fields = super
    fields.sub('{{OTHER}}', other_input.html_safe).html_safe
  end

  def input_type
    :radio_buttons
  end

  def value
    @value ||= @builder.object.public_send(attribute_name)
  end

  def collection
    @collection || begin
      options[:collection] = extract_collection_from_choices if !options[:collection] && !options[:original_collection]
      options[:original_collection] ||= options[:collection]
      items = options[:original_collection].dup
      keys = items.map &:last
      items << ['{{OTHER}}', (keys.include?(value) ? 'other' : value)]
      @collection = items
    end
  end

  def other_input
    if @builder.is_a?(FormViewBuilder)
      if value.is_a?(Array)
        values.present? ? values.to_sentence : ''
      else
        value || ''
      end
    else
      other_value = options[:original_collection].map(&:last).include?(value) ? nil : value
      "<input type=\"text\" value=\"#{other_value}\" data-type=\"other-radio-button\">"
    end
  end

end