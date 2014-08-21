module NoCms
  module Menus
    include ActiveSupport::Configurable

    config_accessor :menu_kinds
    config_accessor :cache_enabled
    config_accessor :localize_urls

    self.menu_kinds = { }
    self.cache_enabled = false
    self.localize_urls = false

  end
end
