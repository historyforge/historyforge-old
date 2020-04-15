module Cms
  module MenuHelper

    def menu(name, *args)
      options = args.extract_options!
      menu = Cms::Menu.where(name: name).first
      return unless menu
      presenter = options[:presenter] || Cms::MenuPresenter
      presenter.new(menu, current_user, self).to_html
    end

    def menu_list(menu, items)
      list = menu_list_items(menu, items)
      ul_options = { class: menu.css_class || 'nav' }
      ul_options[:id] = menu.css_id if menu.css_id
      content_tag :ul, list, ul_options
    end

    def menu_list_items(_, items)
      items.map do |item, children|
        public_send(item.theme_callback, item, children)
      end.join.html_safe
    end

    def menu_list_item(item, children, is_in_dropdown=false)
      li_options = { class: item.css_class || 'nav-item' }
      li_options[:id] = item.css_id if item.css_id
      li_options[:class] << ' active' if public_send(item.active_callback, item.formatted_url)
      if is_in_dropdown
        return link_to(item.title, item.formatted_url, class: 'dropdown-item').html_safe
      elsif item.show_as_expanded? && children.present?
        link = link_to(item.title, item.formatted_url, class: 'nav-link dropdown-toggle', data: { toggle: 'dropdown' }).html_safe
        li_options[:class] << ' dropdown'
        submenu_items = children.keys.map { |child| public_send(child.theme_callback || :menu_list_item, child, true) }.join.html_safe
        link << content_tag(:ul, submenu_items, class: 'dropdown-menu')
      else
        link = link_to(item.title, item.formatted_url, class: 'nav-link').html_safe
      end
      content_tag :li, link, li_options
    end

    def tab_menu_list_item(item)
      li_options = { class: item.css_class || '' }
      li_options[:id] = item.css_id if item.css_id
      li_options[:class] << ' active' if public_send(item.active_callback, item.formatted_url)
      link = link_to(item.title, item.formatted_url).html_safe
      content_tag :li, link, li_options
    end

  end
end
