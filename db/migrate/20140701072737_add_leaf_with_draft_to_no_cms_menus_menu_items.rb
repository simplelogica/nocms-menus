active_record_migration_class =
  if Rails::VERSION::MAJOR >= 5
    ActiveRecord::Migration[Rails::VERSION::MAJOR.to_f]
  else
    ActiveRecord::Migration
  end

class AddLeafWithDraftToNoCmsMenusMenuItems < active_record_migration_class
  def change
    add_column :no_cms_menus_menu_items, :leaf_with_draft, :boolean, default: false
  end
end
