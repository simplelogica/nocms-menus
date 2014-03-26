class AddControllerAndActionToNoCmsMenusMenuItem < ActiveRecord::Migration
  def change
    add_column :no_cms_menus_menu_items, :menu_action, :string
  end
end
