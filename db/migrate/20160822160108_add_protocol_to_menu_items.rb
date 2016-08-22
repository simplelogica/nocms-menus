class AddProtocolToMenuItems < ActiveRecord::Migration
  def change
    add_column :no_cms_menus_menu_items, :protocol, :string
  end
end
