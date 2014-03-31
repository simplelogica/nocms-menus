# This migration comes from no_cms_menus (originally 20140331124833)
class AddPositionToNoCmsMenusMenuItems < ActiveRecord::Migration
  def change
    add_column :no_cms_menus_menu_items, :position, :integer
  end
end
