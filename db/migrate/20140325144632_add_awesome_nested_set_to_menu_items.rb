active_record_migration_class =
  if Rails::VERSION::MAJOR >= 5
    ActiveRecord::Migration[Rails::VERSION::MAJOR.to_f]
  else
    ActiveRecord::Migration
  end

class AddAwesomeNestedSetToMenuItems < active_record_migration_class
  def change
    add_column :no_cms_menus_menu_items, :parent_id, :integer
    add_column :no_cms_menus_menu_items, :lft, :integer
    add_column :no_cms_menus_menu_items, :rgt, :integer
    add_column :no_cms_menus_menu_items, :depth, :integer
  end
end
