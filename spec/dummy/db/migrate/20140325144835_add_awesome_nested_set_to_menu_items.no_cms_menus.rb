# This migration comes from no_cms_menus (originally 20140325144632)
class AddAwesomeNestedSetToMenuItems < ActiveRecord::Migration
  def change
    add_column :no_cms_menus_menu_items, :parent_id, :integer
    add_column :no_cms_menus_menu_items, :lft, :integer
    add_column :no_cms_menus_menu_items, :rgt, :integer
    add_column :no_cms_menus_menu_items, :depth, :integer
  end
end
