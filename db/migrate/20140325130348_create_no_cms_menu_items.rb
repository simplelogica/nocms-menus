active_record_migration_class =
  if Rails::VERSION::MAJOR >= 5
    ActiveRecord::Migration[Rails::VERSION::MAJOR.to_f]
  else
    ActiveRecord::Migration
  end

class CreateNoCmsMenuItems < active_record_migration_class
  def change
    create_table :no_cms_menus_menu_items do |t|
      t.belongs_to :menu, index: true

      t.timestamps null: false
    end

    create_table :no_cms_menus_menu_item_translations do |t|
      t.belongs_to :no_cms_menus_menu_item, index: { name: 'no_cms_menu_item_on_translations' }
      t.string :locale

      t.string :name
      t.timestamps null: false
    end
  end
end
