# There are some issues between the mysql2 gem and Rails 4.0 that must be solved
# with an initializer.
#
# More information in: https://github.com/brianmario/mysql2/issues/784#issuecomment-414878642
if NoCms::Menus.installed_db_gem == "mysql2" and Rails.version < "4.1"

  require 'active_record/connection_adapters/abstract_mysql_adapter'

  class ActiveRecord::ConnectionAdapters::Mysql2Adapter
    NATIVE_DATABASE_TYPES[:primary_key] = "int(11) auto_increment PRIMARY KEY"
  end

end
