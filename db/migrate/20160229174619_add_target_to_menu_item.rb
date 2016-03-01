class AddTargetToMenuItem < ActiveRecord::Migration
  def change
    add_column :no_cms_menus_menu_items, :target, :string
  end
end
