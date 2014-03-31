class AddPositionToNoCmsMenusMenuItems < ActiveRecord::Migration
  def change
    add_column :no_cms_menus_menu_items, :position, :integer
  end
end
