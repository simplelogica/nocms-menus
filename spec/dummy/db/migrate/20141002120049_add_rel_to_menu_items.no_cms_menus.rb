# This migration comes from no_cms_menus (originally 20141002111539)
class AddRelToMenuItems < ActiveRecord::Migration
  def change
    add_column :no_cms_menus_menu_items, :rel, :string
  end
end
