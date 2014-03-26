class AddExternalUrlToNoCmsMenuItemsMenuItem < ActiveRecord::Migration
  def change
    add_column :no_cms_menus_menu_item_translations, :external_url, :string
  end
end
