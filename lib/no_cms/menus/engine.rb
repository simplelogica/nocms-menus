require 'globalize'
require 'awesome_nested_set'

module NoCms
  module Menus
    class Engine < ::Rails::Engine
      isolate_namespace NoCms::Menus
    end
  end
end
