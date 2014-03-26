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
      content = menu_item.name
      content += content_tag(:ul) do
          raw menu_item.children.map{|c| show_submenu c }.join
        end unless menu_item.children.blank?
      content
    end
  end

  def menu_activation_params
    {
      object: @page,
      action: "#{params[:controller]}##{params[:action]}"
    }
  end

end
