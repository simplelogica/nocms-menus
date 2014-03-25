class CreateNoCmsMenusMenus < ActiveRecord::Migration
  def change
    create_table :no_cms_menus_menus do |t|
      t.string :uid
      t.timestamps
    end

    create_table :no_cms_menus_menu_translations do |t|
      t.belongs_to :no_cms_menus_menu, index: true
      t.string :locale

      t.string :name
      t.timestamps
    end
  end
end
