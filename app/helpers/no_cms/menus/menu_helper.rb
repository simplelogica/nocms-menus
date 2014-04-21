module NoCms::Menus::MenuHelper

  def show_menu uid, options = {}
    menu = NoCms::Menus::Menu.find_by(uid: uid)
    return '' if menu.nil?

    options.reverse_merge! menu_class: 'menu'

    content_tag(:ul, class: options[:menu_class]) do
      raw menu.menu_items.roots.no_drafts.reorder(position: :asc).map{|r| show_submenu r, options }.join
    end
  end

  def show_submenu menu_item, options = {}

    has_children = (!options[:depth] || (menu_item.depth < options[:depth]-1)) && # There's no depth option or we are below that depth AND
      !menu_item.children.blank? # This menu item has children

    options.reverse_merge! current_class: 'active', with_children_class: 'has-children'

    item_classes = ['menu_item']
    item_classes << options[:current_class] if menu_item.active_for?(menu_activation_params) || menu_item.descendants.active_for(menu_activation_params).exists?
    item_classes << options[:with_children_class] if has_children

    content_tag(:li, class: item_classes.join(' ')) do
      content = link_to menu_item.name, url_for(menu_item.url_for)
      content += show_children_submenu(menu_item, options) if has_children
      content
    end
  end

  def show_children_submenu menu_item, options = {}
    has_children = (!options[:depth] || (menu_item.depth < options[:depth]-1)) && # There's no depth option or we are below that depth AND
      !menu_item.children.blank? # This menu item has children

    options.reverse_merge! current_class: 'active', with_children_class: 'has-children'

    submenu_id = options.delete :submenu_id
    if options[:submenu_class].is_a? Array
      submenu_class = options[:submenu_class].shift
    else
      submenu_class = options.delete :submenu_class
    end

    content_tag(:ul, id: submenu_id, class: submenu_class) do
      raw menu_item.children.no_drafts.reorder(position: :asc).map{|c| show_submenu c, options }.join
    end if has_children
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

  def current_menu_items_in_menu menu
    menu = NoCms::Menus::Menu.find_by(uid: menu) if menu.is_a? String
    return NoCms::Menus::MenuItem.none if menu.nil?
    menu.menu_items.active_for menu_activation_params
  end

  def current_roots_in_menu menu
    menu = NoCms::Menus::Menu.find_by(uid: menu) if menu.is_a? String
    return NoCms::Menus::MenuItem.none if menu.nil?
    current_menu_items_in_menu_at_level menu, 1
  end

  def current_menu_items_in_menu_at_level menu, level
    menu = NoCms::Menus::Menu.find_by(uid: menu) if menu.is_a? String
    return NoCms::Menus::MenuItem.none if menu.nil?
    current_menu_items_in_menu(menu).map{|c| c.self_and_ancestors.where(depth: level-1) }.flatten
  end
end
