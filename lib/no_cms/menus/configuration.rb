module NoCms
  module Menus
    include ActiveSupport::Configurable

    config_accessor :menu_kinds
    config_accessor :cache_enabled
    config_accessor :localize_urls

    self.menu_kinds = { }
    self.cache_enabled = false
    self.localize_urls = false

    def self.installed_db_gem
      installed_db_gem  = ['mysql2', 'pg'].detect do |db_gem|
        begin
          Gem::Specification.find_by_name(db_gem)
        rescue Gem::LoadError
          false
        rescue
          Gem.available?(db_gem)
        end
      end

      raise 'Neither mysql2 nor pg gems have been detected' unless installed_db_gem

      installed_db_gem

    end

  end
end
