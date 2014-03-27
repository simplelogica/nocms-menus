module NoCms::Menus::MenuHelper

  def show_menu uid
    menu = NoCms::Menus::Menu.find_by(uid: uid)
    return '' if menu.nil?

    content_tag(:ul, class: 'menu') do
      raw menu.menu_items.roots.map{|r| show_submenu r }.join
    end
  end

  def show_submenu menu_item
    item_class = 'menu_item'

    item_class += ' active' if menu_item.active_for?(menu_activation_params) || menu_item.children.active_for(menu_activation_params).exists?

    content_tag(:li, class: item_class) do
      content = link_to menu_item.name, url_for(menu_item.url_for)
      content += content_tag(:ul) do
          raw menu_item.children.map{|c| show_submenu c }.join
        end unless menu_item.children.blank?
      content
    end
  end

  def menu_activation_params
    {
      object: menu_object,
      action: "#{params[:controller]}##{params[:action]}"
    }
  end

  def menu_object
    return @menu_object unless @menu_object.nil?
    @menu_object ||= instance_variable_get("@#{menu_object_name}")
  end

  def menu_object_name
    controller.controller_name.singularize
  end

end
