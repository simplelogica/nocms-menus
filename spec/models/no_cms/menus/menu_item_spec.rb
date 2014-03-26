require 'spec_helper'

describe NoCms::Menus::Menu do

  it_behaves_like "model with required attributes", :no_cms_menus_menu, [:name]
  it_behaves_like "model with has many relationship", :no_cms_menus_menu_item, :no_cms_menus_menu_item, :children, :parent
  it_behaves_like "model with has many relationship", :page, :no_cms_menus_menu_item, :menu_items, :menuable

  context "detecting active menu items" do

    let(:action_menu_item) { create :no_cms_menus_menu_item, menu_action: menu_action }
    let(:menu_action) { 'pages#show' }
    let(:external_url_menu_item) { create :no_cms_menus_menu_item, external_url: external_url }
    let(:external_url) { Faker::Internet.domain_name }
    let(:page_menu_item) { create :no_cms_menus_menu_item, menuable: page }
    let(:page) { create :page }
    let(:other_menu_items) { create_list :no_cms_menus_menu_item, 2 }
    let(:other_page_menu_item) { create :no_cms_menus_menu_item, menuable: other_page }
    let(:other_page) { create :page }


    before { action_menu_item && external_url_menu_item && page_menu_item && other_menu_items && other_page_menu_item }


    context "when attached to an object" do

      subject { page_menu_item }

      it "should detect only those attached to that object" do
        expect(NoCms::Menus::MenuItem.active_for(object: page)).to eq [page_menu_item]
      end

    end

    context "when attached to an action" do

      subject { action_menu_item }

      it "should detect only those attached to that object" do
        expect(NoCms::Menus::MenuItem.active_for(action: menu_action)).to eq [action_menu_item]
      end

    end

    context "when attached to an external url" do

      subject { action_menu_item }

      it "should detect only those attached to that object" do
        expect(NoCms::Menus::MenuItem.active_for(url: external_url)).to eq [external_url_menu_item]
      end

    end

    context "when attached to nothing" do

      subject { action_menu_item }

      it "should not detect nothing" do
        expect(NoCms::Menus::MenuItem.active_for).to be_blank
      end

    end

  end

end
