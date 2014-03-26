require 'spec_helper'

describe NoCms::Menus::Menu do

  it_behaves_like "model with required attributes", :no_cms_menus_menu, [:name]
  it_behaves_like "model with has many relationship", :no_cms_menus_menu_item, :no_cms_menus_menu_item, :children, :parent
  it_behaves_like "model with has many relationship", :page, :no_cms_menus_menu_item, :menu_items, :menuable

  context "detecting active menu items" do

    context "when attached to an object" do

      let(:page_menu_item) { create :no_cms_menus_menu_item, menuable: page }
      let(:page) { create :page }
      let(:other_menu_items) { create_list :no_cms_menus_menu_item, 2 }
      let(:other_page_menu_item) { create :no_cms_menus_menu_item, menuable: other_page }
      let(:other_page) { create :page }


      before { page_menu_item && other_menu_items && other_page_menu_item }

      subject { page_menu_item }

      it "should detect only those attached to that object" do
        expect(NoCms::Menus::MenuItem.active_for(object: page)).to eq [page_menu_item]
      end

    end

  end

end
