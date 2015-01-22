NoCms::Menus.configure do |config|

  # In this section we configure which options will be available in the menus selector.
  # Menu kinds may contain:
  #   - A class in object_class option. Then the admin would show all the objects of that class.
  #   - An action in action option. Then the admin will store this action.
  # An external url kind will be added automatically
  # E.g: config.menu_kinds = {
  #   'page' => {
  #     object_class: Page,
  #   },
  #   'agenda' => {
  #     action: 'events#index'
  #   },
  #   'fixed_url' => {
  #     external_url:  true
  #   }
  # }

  config.menu_kinds = {
    'page' => {
      object_class: Page,
    },
    'products' => {
      action: 'products#index'
    },
    'product' => {
      object_class: Product,
    },
    'any_product' => {
      action: 'products#show',
      hidden: true
    },
    'pages' => {
      action: 'pages#index'
    },
    'tests' => {
      route_set: 'test_engine',
      action: 'test_engine/tests#index'
    },
    'recent_tests' => {
      route_set: 'test_engine',
      action: 'test_engine/tests#recent'
    },
    'fixed_url' => {
      external_url:  true
    }
  }
end
