module NoCms
  module Menus
    include ActiveSupport::Configurable

    config_accessor :menu_kinds

    self.menu_kinds = { }

  end
end
