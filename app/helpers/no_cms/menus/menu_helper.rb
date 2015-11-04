module NoCms::Menus::MenuHelper

  def active_menu_item_ids menu
    menu.menu_items.active_for(menu_activation_params).map{|i| i.self_and_ancestors.pluck(:id)}.flatten.uniq
  end

  def leaf_menu_item_ids menu
    menu.menu_items.leaves_with_draft.no_drafts.pluck(:id)
  end

  def conditional_cache_menu menu, cache_options = {}
    cache_options = cache_options.dup
    cache_options.reverse_merge! initial_cache_key: 'menu-', cache_enabled: NoCms::Menus.cache_enabled

    if cache_options[:cache_enabled]
      Rails.cache.fetch cache_key_for_menu(menu, cache_options) do
        yield
      end
    else
      yield
    end
  end

  def cache_key_for_menu menu, options = {}
    options[:timestamp] ||= [menu.updated_at, menu.menu_items.maximum(:updated_at)].max.to_i
    options[:active_menu_items] ||= active_menu_item_ids menu

    "menus/#{options[:initial_cache_key]}-#{menu.uid}-" + # We use the menu uid
    "#{options[:timestamp]}" + # And the last updated date from the last updated item (or the menu itself)
    "-#{options[:active_menu_items].join("_")}" # And which menu items should be selected
  end

  def show_menu menu_or_uid, options = {}
    menu =
    if menu_or_uid.is_a? NoCms::Menus::Menu
      menu_or_uid
    else
      NoCms::Menus::Menu.find_by(uid: menu_or_uid)
    end
    return '' if menu.nil?

    options[:active_menu_items] ||= active_menu_item_ids menu

    conditional_cache_menu menu, options do

      options.reverse_merge! menu_class: 'menu'
      options[:leaves_menu_items] ||= leaf_menu_item_ids menu

      content_tag(:ul, class: options[:menu_class]) do
        raw menu.menu_items.roots.no_drafts.includes(:translations).reorder(position: :asc).map{|r| show_submenu r, options }.join
      end.to_s
    end

  end

  def show_submenu menu_item, options = {}

    return '' if menu_item.draft?

    options[:active_menu_items] ||= active_menu_item_ids menu_item.menu
    options = options.reverse_merge(initial_cache_key: "submenu-#{menu_item.id}")

    conditional_cache_menu menu_item.menu, options.merge(initial_cache_key: "#{options[:initial_cache_key]}/#{menu_item.id}/#{menu_item.updated_at.to_i}") do
      options[:leaves_menu_items] ||= leaf_menu_item_ids menu_item.menu
      has_children = (!options[:depth] || (menu_item.depth < options[:depth]-1)) && # There's no depth option or we are below that depth AND
        !options[:leaves_menu_items].include?(menu_item.id) # This menu item is not a leaf

      options.reverse_merge! current_class: 'active', with_children_class: 'has-children'

      item_classes = ['menu_item']
      item_classes << options[:current_class] if options[:active_menu_items].include?(menu_item.id)
      item_classes << options[:with_children_class] if has_children
      item_classes += menu_item.css_class.split(' ') unless menu_item.css_class.blank?

      content_tag(:li, class: item_classes.join(' ')) do

        # And finally get the link
        content = link_to_menu_item menu_item
        content += show_children_submenu(menu_item, options) if has_children
        content
      end
    end
  end

  def show_children_submenu menu_item, options = {}
    options = options.dup

    options[:active_menu_items] ||= active_menu_item_ids menu_item.menu
    options = options.reverse_merge(initial_cache_key: "children-submenu-#{menu_item.id}")

    conditional_cache_menu menu_item.menu, options.merge(initial_cache_key: "#{options[:initial_cache_key]}/#{menu_item.id}/#{menu_item.updated_at.to_i}") do

      options[:leaves_menu_items] ||= leaf_menu_item_ids menu_item.menu
      has_children = (!options[:depth] || (menu_item.depth < options[:depth]-1)) && # There's no depth option or we are below that depth AND
        !options[:leaves_menu_items].include?(menu_item.id) # This menu item is not a leaf

      options.reverse_merge! current_class: 'active', with_children_class: 'has-children'

      submenu_id = options.delete :submenu_id
      if options[:submenu_class].is_a? Array
        options[:submenu_class] = options[:submenu_class].dup
        submenu_class = options[:submenu_class].shift
      else
        submenu_class = options.delete :submenu_class
      end

      content_tag(:ul, id: submenu_id, class: submenu_class) do
        raw menu_item.children.no_drafts.includes(:translations).reorder(position: :asc).map{|c| show_submenu c, options }.join
      end if has_children
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

  def menu_item_path menu_item
    # If this menu item points to a route in other engine we need that engines route set
    menu_item_route_set = menu_item.route_set.nil? ? main_app : send(menu_item.route_set)
    # Now we get the url_for info and if it's a hash then add the :only_path option
    url_info =  menu_item.url_for
    url_info[:only_path] = true if url_info.is_a? Hash

    # When url_info is an ActiveRecord object we have to use polymorphic_path instead of url_for
    url_info.is_a?(ActiveRecord::Base) ? menu_item_route_set.polymorphic_path(url_info) :  menu_item_route_set.url_for(url_info)
  end

  def link_to_menu_item menu_item, link_options={}
    # Adding link options (turbolink and rel)
    link_options['data-no-turbolink'] = true unless menu_item.turbolinks
    link_options[:rel] = menu_item.rel unless menu_item.rel.blank?

    # And finally get the link
    link_to menu_item.name, menu_item_path(menu_item), link_options
  end
end
