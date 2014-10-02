# This migration comes from no_cms_menus (originally 20140718104648)
class AddTurbolinksToMenuItem < ActiveRecord::Migration
  def change
    add_column :no_cms_menus_menu_items, :turbolinks, :boolean
  end
end
