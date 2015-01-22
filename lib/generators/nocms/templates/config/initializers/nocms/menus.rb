NoCms::Menus.configure do |config|

  # Enable cache in the standard menu helpers globally
  # Note that you can override this setting by sending the option :cache true or false when calling the menu helpers
  # e.g: show_menu 'menu_name', depth: 2, menu_class: 'nav', cache: true
  # config.cache_enabled = false

  # When using some gem like 'route_translator' for urls internacionalization we need the locale to be set on the urls
  # This setting must be enabled (set to true) if you are using i18n routes
  # config.localize_urls = false

  # In this section we configure which options will be available in the menus selector.
  # Menu kinds may contain:
  #   - A class in object_class option. Then the admin would show all the objects of that class.
  #   - An action in action option. Then the admin will store this action.
  # An external url kind will be added automatically
  # E.g: config.menu_kinds = {
  #   'page' => {
  #     object_class: Page,
  #     object_name_method: :title, # This is used for displaying the name
  #       # of the item in nocms-admin-menus
  #     hidden: false # This flag marks that items from this kind must be ALWAYS hidden
  #       # This is useful for some kinds of menu items that do not create a valid url
  #       # e.g. Those attached to an 'events#show' action, with no actual event,
  #       # that have to activate its parent.
  #   },
  #   'agenda' => {
  #     action: 'events#index'
  #   },
  #   'fixed_url' => {
  #     external_url:  true
  #   }
  # }

end
