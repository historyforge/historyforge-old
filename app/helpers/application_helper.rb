module ApplicationHelper

  def prepare_alerts_base
    js = []
    js << ['success', message_for_item(flash[:notice], :notice_item)] unless flash[:notice].blank?
    js << ['error', message_for_item(flash[:errors], :errors_itme)] unless flash[:errors].blank?
    js << ['log', message_for_item(flash[:alert], :alert_item)] unless flash[:alert].blank?
    js << ['log', message_for_item(flash[:warning], :warning_item)] unless flash[:warning].blank?
    js
  end

  def flash_messages
    javascript_tag "window.alerts=#{prepare_alerts_base.to_json};"
  end

  def prepare_xhr_alerts
    prepare_alerts_base.map { |key, value|
      content_tag(:div, value, :class => 'alert hidden', 'data-alert' => key)
    }.join('')
  end

  def admin_authorized?
    user_signed_in? && current_user.has_role?('administrator')
  end

  def message_for_item(message, item = nil)
    if item.is_a?(Array)
     raw message % link_to(*item)
    else
      message % item
    end
  end

  def strip_brackets(str)
    str ||=""
    str.gsub(/[\]\[()]/,"")
  end

  def snippet(thought, wordcount)
    if thought
      thought.split[0..(wordcount-1)].join(" ") +(thought.split.size > wordcount ? "..." : "")
    end
  end

  def error_messages_for(*objects)
    options = objects.extract_options!
    options[:header_message] ||= I18n.t(:"activerecord.errors.header", :default => "Invalid Fields")
    options[:message] ||= I18n.t(:"activerecord.errors.message", :default => "Correct the following errors and try again.")
    messages = objects.compact.map { |o| o.errors.full_messages }.flatten
    unless messages.empty?
      content_tag(:div, :class => "error_messages") do
        list_items = messages.map { |msg| content_tag(:li, msg) }
        content_tag(:h2, options[:header_message]) + content_tag(:p, options[:message]) + content_tag(:ul, list_items.join.html_safe)
      end
    end
  end

  def assets(directory)
    assets = {}

    Rails.application.assets.index.each_logical_path("#{directory}/*") do |path|
      assets[path.sub(/^#{directory}\//, "")] = asset_path(path)
    end

    assets
  end

  def picture_tag(photo: nil, style: 'quarter', img_class: 'img-thumb')
    render 'shared/picture', id: photo.id, style: style, alt_text: photo.caption, img_class: img_class
  end

  def checkbox_button(label, attr, checked)
    render 'shared/checkbox_button',
           active_class: checked ? 'active' : '',
           attr: attr,
           label: label,
           checked: checked
  end
end
