class AddTurbolinksToMenuItem < ActiveRecord::Migration
  def change
    add_column :no_cms_menus_menu_items, :turbolinks, :boolean
  end
end
