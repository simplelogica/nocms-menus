require 'spec_helper'

describe NoCms::Menus do

  let(:menu) { create :no_cms_menus_menu, uid: 'test' }

  let(:action_menu_item) { create :no_cms_menus_menu_item, menu: menu, menu_action: 'pages#index', kind: 'pages' }
  let(:child_action_menu_item) { create :no_cms_menus_menu_item, menu: menu, menu_action: 'pages#index', parent: action_menu_item, kind: 'pages' }

  let(:engine_action_menu_item) { create :no_cms_menus_menu_item, menu: menu, menu_action: 'test_engine/tests#index', kind: 'tests' }
  let(:engine_child_action_menu_item) { create :no_cms_menus_menu_item, menu: menu, menu_action: 'test_engine/tests#recent', parent: engine_action_menu_item, kind: 'recent_tests' }

  let(:parent_page) { create :page }
  let(:parent_menu_item) { create :no_cms_menus_menu_item, menu: menu, menuable: parent_page, kind: 'page' }

  let(:child_page) { create :page }
  let(:child_page_menu_item) { create :no_cms_menus_menu_item, menu: menu, menuable: child_page, parent: parent_menu_item, kind: 'page' }

  let(:page_with_no_menu) { create :page }

  let(:product) { create :product }
  let(:product_menu_item) { create :no_cms_menus_menu_item, menu: menu, menuable: product, kind: 'product' }

  let(:external_url_menu_item) { create :no_cms_menus_menu_item, menu: menu, external_url: external_url, kind: 'fixed_url' }
  let(:external_url) { 'http://www.google.com' }

  let(:wrong_route_menu_item) { create :no_cms_menus_menu_item, menu: menu, menu_action: 'not#exists', kind: 'wrong_route_menu_item' }

  before do
    parent_menu_item
    child_page_menu_item
    page_with_no_menu
    child_action_menu_item
    engine_child_action_menu_item
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

    it "should render link to an action in other engine (tests index)" do
      expect(subject).to have_selector ".menu .menu_item a[href='#{test_engine.tests_path}']"
    end

    it "should render link to an object with custom path (page)" do
      expect(subject).to have_selector ".menu .menu_item.has-children a[href='#{parent_page.path}']"
    end

    it "should render link to an object without custom path (product)" do
      expect(subject).to have_selector ".menu .menu_item a[href='#{product_path(product)}']"
    end

    it "should render link to an external url" do
      expect(subject).to have_selector ".menu .menu_item a[href='#{external_url}']"
    end

    context "when drafting some menu item" do

      before do
        child_page_menu_item.update_attributes draft: true;
        visit pages_path
      end

      it "should not render its parent as having children" do
        expect(subject).to have_selector ".menu .menu_item a[href='#{parent_page.path}']"
        expect(subject).to_not have_selector ".menu .menu_item.has-children a[href='#{parent_page.path}']"
      end

    end

    context "when we have a menu item with wrong routes" do

      context "when it's drafted by configuration" do


        before do
          # We configure the menu kind as hidden
          wrong_route_menu_item
        end

        it "doesn't throw any exception" do
          expect{visit pages_path}.to_not raise_error
        end

      end

      context "when it's drafted by configuration after it was created" do


        before do
          # We configure the menu kind as hidden
          NoCms::Menus.menu_kinds['wrong_route_menu_item'].delete :hidden
          wrong_route_menu_item
          NoCms::Menus.menu_kinds['wrong_route_menu_item'][:hidden] = true
        end

        it "doesn't throw any exception" do
          expect{visit pages_path}.to_not raise_error
        end

      end

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


  context "when visiting actions in another engine" do

    context "when attached to a menu item" do

      before do
        visit test_engine.tests_path
      end

      it "should mark that item as active" do
        expect(subject).to have_selector '.menu .menu_item.active', text: engine_action_menu_item.name
      end

    end

    context "when attached to a nested menu item" do

      before do
        visit test_engine.recent_tests_path
      end

      it "should mark that item as active" do
        expect(subject).to have_selector '.menu .menu_item.active', text: engine_child_action_menu_item.name
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

    context "when product has no menu item attached" do

      let(:products_menu_item) { create :no_cms_menus_menu_item, menu: menu, kind: 'products', menu_action: 'products#index' }
      let(:product_without_menu_item) { create :product }

      before do
        products_menu_item
        product_without_menu_item
      end

      context "and menu has any product item" do
        let(:any_product_menu_item) { create :no_cms_menus_menu_item, menu: menu, kind: 'any_product', parent: products_menu_item, menu_action: 'products#show'  }

        before do
          any_product_menu_item
          visit product_path(product_without_menu_item)
        end

        it "should mark products item as active" do
          expect(subject).to have_selector '.menu .menu_item.active', text: products_menu_item.name
        end
      end

      context "and menu has no any product item" do
        before do
          visit product_path(product_without_menu_item)
        end

        it "should not mark products item as active" do
          expect(subject).to_not have_selector '.menu .menu_item.active'
        end

      end
    end

  end


end
