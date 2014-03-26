require 'spec_helper'

describe NoCms::Menus do

  let(:the_page) { create :page }
  let(:page_with_no_menu) { create :page }
  let(:menu_item) { create :no_cms_menus_menu_item, menu: menu, menuable: the_page }
  let(:menu) { create :no_cms_menus_menu, uid: 'test' }

  before do
    menu_item
    page_with_no_menu
  end

  context "when visiting pages" do

    context "when page has no menu_item attached" do

      before do
        visit page_path page_with_no_menu
      end

      subject { page }

      it "should not mark any item as active" do
        expect(subject).to_not have_selector '.menu .menu_item.active'
      end

    end

    context "when visiting a page with a menu item" do

      before do
        visit page_path the_page
      end

      subject { page }

      it "should mark that item as active" do
        expect(subject).to have_selector '.menu .menu_item.active', text: menu_item.name
      end

    end
  end


end
