module NoCms
  class MenusGenerator < Rails::Generators::Base

    source_root File.expand_path("../templates/", __FILE__)

    def generate_nocms_menus_initializer
      template "config/initializers/nocms/menus.rb", File.join(destination_root, "config", "initializers", "nocms", "menus.rb")
    end

    def self.namespace
      "nocms:menus"
    end

  end
end
