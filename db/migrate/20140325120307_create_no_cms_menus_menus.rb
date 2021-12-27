active_record_migration_class =
  if Rails::VERSION::MAJOR >= 5
    ActiveRecord::Migration[Rails::VERSION::MAJOR.to_f]
  else
    ActiveRecord::Migration
  end

class CreateNoCmsMenusMenus < active_record_migration_class
  def change
    create_table :no_cms_menus_menus do |t|
      t.string :uid
      t.timestamps null: false
    end

    create_table :no_cms_menus_menu_translations do |t|
      t.belongs_to :no_cms_menus_menu, index: true
      t.string :locale

      t.string :name
      t.timestamps null: false
    end
  end
end
