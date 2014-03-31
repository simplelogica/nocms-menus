NoCms::Menus.configure do |config|

  # In this section we configure which options will be available in the menus selector.
  # Menu kinds may contain:
  #   - A class in object_class option. Then the admin would show all the objects of that class.
  #   - An action in action option. Then the admin will store this action.
  # An external url kind will be added automatically
  # E.g: config.menu_kinds = {
  #   'page' => {
  #     object_class: Page,
  #     object_name_method: :title # This is used for displaying the name
  #       # of the item in nocms-admin-menus
  #   },
  #   'agenda' => {
  #     action: 'events#index'
  #   },
  #   'fixed_url' => {
  #     external_url:  true
  #   }
  # }

end
