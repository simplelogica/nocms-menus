class AddCssClassToMenuItem < ActiveRecord::Migration
  def change
    add_column :no_cms_menus_menu_items, :css_class, :string
  end
end
