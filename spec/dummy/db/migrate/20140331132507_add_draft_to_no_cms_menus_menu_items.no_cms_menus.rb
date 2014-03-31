# This migration comes from no_cms_menus (originally 20140331132336)
class AddDraftToNoCmsMenusMenuItems < ActiveRecord::Migration
  def change
    add_column :no_cms_menus_menu_item_translations, :draft, :boolean
  end
end
