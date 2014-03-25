require 'spec_helper'

describe NoCms::Menus::Menu do

  it_behaves_like "model with required attributes", :no_cms_menus_menu, [:name]
  it_behaves_like "model with has many relationship", :no_cms_menus_menu_item, :no_cms_menus_menu_item, :children, :parent
  it_behaves_like "model with has many relationship", :page, :no_cms_menus_menu_item, :menu_items, :menuable

end
