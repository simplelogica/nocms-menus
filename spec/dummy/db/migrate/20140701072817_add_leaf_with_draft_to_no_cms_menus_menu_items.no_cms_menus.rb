# This migration comes from no_cms_menus (originally 20140701072737)
class AddLeafWithDraftToNoCmsMenusMenuItems < ActiveRecord::Migration
  def change
    add_column :no_cms_menus_menu_items, :leaf_with_draft, :boolean, default: false
  end
end
