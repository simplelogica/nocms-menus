# This migration comes from no_cms_menus (originally 20140326091653)
class AddExternalUrlToNoCmsMenuItemsMenuItem < ActiveRecord::Migration
  def change
    add_column :no_cms_menus_menu_item_translations, :external_url, :string
  end
end
