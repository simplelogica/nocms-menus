require 'spec_helper'

describe NoCms::Menus do

  let(:menu) { create :no_cms_menus_menu, uid: 'test' }

  let(:action_menu_item) { create :no_cms_menus_menu_item, menu: menu, menu_action: 'pages#index' }
  let(:child_action_menu_item) { create :no_cms_menus_menu_item, menu: menu, menu_action: 'pages#index', parent: action_menu_item }

  let(:parent_page) { create :page }
  let(:parent_menu_item) { create :no_cms_menus_menu_item, menu: menu, menuable: parent_page }

  let(:child_page) { create :page }
  let(:child_page_menu_item) { create :no_cms_menus_menu_item, menu: menu, menuable: child_page, parent: parent_menu_item }

  let(:page_with_no_menu) { create :page }

  let(:product) { create :product }
  let(:product_menu_item) { create :no_cms_menus_menu_item, menu: menu, menuable: product  }

  let(:external_url_menu_item) { create :no_cms_menus_menu_item, menu: menu, external_url: external_url }
  let(:external_url) { 'http://www.google.com' }

  before do
    parent_menu_item
    child_page_menu_item
    page_with_no_menu
    child_action_menu_item
    product_menu_item
    external_url_menu_item
  end

  subject { page }

  context "when rendering links" do
    before do
      visit pages_path
    end

    it "should render link to an action (page index)" do
      expect(subject).to have_selector ".menu .menu_item a[href='#{pages_path}']"
    end

    it "should render link to an object with custom path (page)" do
      expect(subject).to have_selector ".menu .menu_item a[href='#{parent_page.path}']"
    end

    it "should render link to an object without custom path (product)" do
      expect(subject).to have_selector ".menu .menu_item a[href='#{product_path(product)}']"
    end

    it "should render link to an external url" do
      expect(subject).to have_selector ".menu .menu_item a[href='#{external_url}']"
    end

  end

  context "when visiting actions" do

    context "when visiting an action attached to a menu item" do

      before do
        visit pages_path
      end

      it "should mark that item as active" do
        expect(subject).to have_selector '.menu .menu_item.active', text: action_menu_item.name
      end

    end

    context "when visiting an action attached to a nested menu item" do

      before do
        visit pages_path
      end

      it "should mark that item as active" do
        expect(subject).to have_selector '.menu .menu_item.active', text: child_action_menu_item.name
      end

    end

  end

  context "when visiting pages" do

    context "when page has no menu_item attached" do

      before do
        visit page_with_no_menu.path
      end

      it "should not mark any item as active" do
        expect(subject).to_not have_selector '.menu .menu_item.active'
      end

    end

    context "when visiting a page with a menu item" do

      before do
        visit parent_page.path
      end

      it "should mark that item as active" do
        expect(subject).to have_selector '.menu .menu_item.active', text: parent_menu_item.name
      end

      it "should mark only that item as active" do
        expect(subject).to have_selector '.menu .menu_item.active', count: 1
      end

    end

    context "when visiting a page with a nested menu item" do

      before do
        visit child_page.path
      end

      it "should mark that item as active" do
        expect(subject).to have_selector '.menu .menu_item.active', text: child_page_menu_item.name
      end

      it "should mark item's parent as active" do
        expect(subject).to have_selector '.menu .menu_item.active', text: child_page_menu_item.parent.name
      end

    end

  end

  context "when visiting products" do

    context "when visiting a product with a menu item" do

      before do
        visit product_path product
      end

      it "should mark that item as active" do
        expect(subject).to have_selector '.menu .menu_item.active', text: product_menu_item.name
      end

      it "should mark only that item as active" do
        expect(subject).to have_selector '.menu .menu_item.active', count: 1
      end

    end

    context "when products controller doesn't create @product variable" do

      before do
        visit product_path(product, change_name: true)
      end

      it "should not mark that item as active" do
        expect(subject).to_not have_selector '.menu .menu_item.active'
      end

    end

    context "when products controller doesn't create @product variable but set the menu object" do

      before do
        visit product_path(product, change_name: true, set_menu_object: true)
      end

      it "should mark that item as active" do
        expect(subject).to have_selector '.menu .menu_item.active', text: product_menu_item.name
      end


    end

  end


end