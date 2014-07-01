class TranslatingLeafWithDraftToNoCmsMenusMenuItem < ActiveRecord::Migration
  def change
    add_column :no_cms_menus_menu_item_translations, :leaf_with_draft, :boolean, default: false, index: true
    add_index :no_cms_menus_menu_item_translations, :leaf_with_draft
    remove_column :no_cms_menus_menu_items, :leaf_with_draft, :boolean, default: false, index: true
  end
end
