active_record_migration_class =
  if Rails::VERSION::MAJOR >= 5
    ActiveRecord::Migration[Rails::VERSION::MAJOR.to_f]
  else
    ActiveRecord::Migration
  end

class AddTurbolinksToMenuItem < active_record_migration_class
  def change
    add_column :no_cms_menus_menu_items, :turbolinks, :boolean
  end
end
