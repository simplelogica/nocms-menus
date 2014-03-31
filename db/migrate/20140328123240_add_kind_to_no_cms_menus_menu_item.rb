class AddKindToNoCmsMenusMenuItem < ActiveRecord::Migration
  def change
    add_column :no_cms_menus_menu_items, :kind, :string
  end
end
