module NoCms
  module Menus
    include ActiveSupport::Configurable

    config_accessor :menu_kinds
    config_accessor :cache_enabled

    self.menu_kinds = { }
    self.cache_enabled = false

  end
end
