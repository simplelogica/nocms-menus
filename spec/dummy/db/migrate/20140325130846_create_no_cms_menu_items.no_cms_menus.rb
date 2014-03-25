# This migration comes from no_cms_menus (originally 20140325130348)
class CreateNoCmsMenuItems < ActiveRecord::Migration
  def change
    create_table :no_cms_menus_menu_items do |t|
      t.belongs_to :menu, index: true

      t.timestamps
    end

    create_table :no_cms_menus_menu_item_translations do |t|
      t.belongs_to :no_cms_menus_menu_item, index: { name: 'no_cms_menu_item_on_translations' }
      t.string :locale

      t.string :name
      t.timestamps
    end
  end
end
