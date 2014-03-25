class AddMenuableToNoCmsMenusMenuItem < ActiveRecord::Migration
  def change
    add_reference :no_cms_menus_menu_items, :menuable, polymorphic: true, index: true
  end
end
