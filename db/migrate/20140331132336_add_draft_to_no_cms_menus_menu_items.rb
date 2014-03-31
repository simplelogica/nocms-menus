class AddDraftToNoCmsMenusMenuItems < ActiveRecord::Migration
  def change
    add_column :no_cms_menus_menu_item_translations, :draft, :boolean
  end
end
