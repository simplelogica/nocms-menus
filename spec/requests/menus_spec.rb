require 'spec_helper'

describe NoCms::Menus do

  let(:menu) { create :no_cms_menus_menu, uid: 'test' }

  let(:action_menu_item) { create :no_cms_menus_menu_item, menu: menu, menu_action: 'pages#index' }

  let(:parent_page) { create :page }
  let(:parent_menu_item) { create :no_cms_menus_menu_item, menu: menu, menuable: parent_page }

  let(:child_page) { create :page }
  let(:child_page_menu_item) { create :no_cms_menus_menu_item, menu: menu, menuable: child_page, parent: parent_menu_item }

  let(:page_with_no_menu) { create :page }

  before do
    parent_menu_item
    child_page_menu_item
    page_with_no_menu
    action_menu_item
  end

  context "when visiting actions" do

    context "when visiting an action attached to a menu item" do

      before do
        visit pages_path
      end

      subject { page }

      it "should mark that item as active" do
        expect(subject).to have_selector '.menu .menu_item.active', text: action_menu_item.name
      end

    end

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
        visit page_path parent_page
      end

      subject { page }

      it "should mark that item as active" do
        expect(subject).to have_selector '.menu .menu_item.active', text: menu_item.name
      end

    end

    context "when visiting a page with a nested menu item" do

      before do
        visit page_path child_page
      end

      subject { page }

      it "should mark that item as active" do
        expect(subject).to have_selector '.menu .menu_item.active', text: child_page_menu_item.name
      end

      it "should mark item's parent as active" do
        expect(subject).to have_selector '.menu .menu_item.active', text: child_page_menu_item.parent.name
      end

    end

  end


end
