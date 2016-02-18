require 'spec_helper'

describe NoCms::Menus::Menu do

  it_behaves_like "model with required attributes", :no_cms_menus_menu, [:name]
  it_behaves_like "model with has many relationship", :no_cms_menus_menu_item, :no_cms_menus_menu_item, :children, :parent
  it_behaves_like "model with has many relationship", :page, :no_cms_menus_menu_item_for_page, :menu_items, :menuable

  context "detecting active menu items" do

    let(:action_menu_item) { create :no_cms_menus_menu_item, menu_action: menu_action }
    let(:menu_action) { 'pages#show' }
    let(:external_url_menu_item) { create :no_cms_menus_menu_item, external_url: external_url }
    let(:external_url) { Faker::Internet.domain_name }
    let(:page_menu_item) { create :no_cms_menus_menu_item_for_page, menuable: page }
    let(:page) { create :page }
    let(:other_menu_items) { create_list :no_cms_menus_menu_item, 2 }
    let(:other_page_menu_item) { create :no_cms_menus_menu_item_for_page, menuable: other_page }
    let(:other_page) { create :page }


    before { action_menu_item && external_url_menu_item && page_menu_item && other_menu_items && other_page_menu_item }


    context "when attached to an object" do

      it "should detect only those attached to that object" do
        expect(NoCms::Menus::MenuItem.active_for(object: page)).to eq [page_menu_item]
      end

      it "should detect the menu item as active" do
        expect(page_menu_item).to be_active_for object: page
      end

    end

    context "when attached to multiple objects" do

      it "should detect only those attached to an array of objects" do
        expect(NoCms::Menus::MenuItem.active_for(object: [page, other_page])).to match_array [page_menu_item, other_page_menu_item]
      end

      it "should detect only those attached to a scope" do
        expect(NoCms::Menus::MenuItem.active_for(object: Page.all)).to match_array [page_menu_item, other_page_menu_item]
      end

      it "should detect the menu item as active" do
        expect(page_menu_item).to be_active_for object: [page, other_page]
        expect(other_page_menu_item).to be_active_for object: [page, other_page]
      end

    end

    context "when attached to an action" do

      it "should detect only those attached to that object" do
        expect(NoCms::Menus::MenuItem.active_for(action: menu_action)).to eq [action_menu_item]
      end

      it "should detect the menu item as active" do
        expect(action_menu_item).to be_active_for action: menu_action
      end

    end

    context "when attached to an external url" do

      it "should detect only those attached to that object" do
        expect(NoCms::Menus::MenuItem.active_for(url: external_url)).to eq [external_url_menu_item]
      end

      it "should detect the menu item as active" do
        expect(external_url_menu_item).to be_active_for url: external_url
      end

    end

    context "when attached to nothing" do

      it "should not detect nothing" do
        expect(NoCms::Menus::MenuItem.active_for).to be_blank
      end

    end

  end

  context "when creating a menu item" do
    let(:page_menu_item) { create :no_cms_menus_menu_item_for_page, menuable_id: page.id }
    let(:page) { create :page }

    it "should recognize the menuable object even without explictly setting the menuable type" do
      expect(page_menu_item.menuable).to eq page
    end

  end

  context "when hiding menu kinds" do

    let(:old_menu_item) { create :no_cms_menus_menu_item, menu_action: menu_action, kind: 'pages' }
    let(:hidden_menu_item) { create :no_cms_menus_menu_item, menu_action: menu_action, kind: 'pages' }
    let(:menu_action) { 'pages#index' }

    before do
      # We configure the menu kind as hidden
      old_menu_item
      NoCms::Menus.menu_kinds['pages'][:hidden] = true
      hidden_menu_item
    end

    after do
      # And after this test we unconfigure it
      NoCms::Menus.menu_kinds['pages'].delete :hidden
    end

    it "should not be detected as visible" do
      expect(NoCms::Menus::MenuItem.drafts).to be_include hidden_menu_item
    end

    it "should not believe it's visible" do
      expect(hidden_menu_item).to be_draft
    end

    it "should not detect old menu items (created before the change in the config) as visible" do
      expect(old_menu_item).to be_draft
    end

  end

  context "detecting leaf menu items" do
    let(:menu_action) { 'pages#show' }
    let(:menu) { create :no_cms_menus_menu }
    let(:root_leaf_menu_item) { create :no_cms_menus_menu_item, menu_action: menu_action, menu: menu }
    let(:root_menu_item_1) { create :no_cms_menus_menu_item, menu_action: menu_action, menu: menu }
    let(:child_menu_item_1) { create :no_cms_menus_menu_item, menu_action: menu_action, menu: menu, parent: root_menu_item_1 }
    let(:root_menu_item_2) { create :no_cms_menus_menu_item, menu_action: menu_action, menu: menu }
    let(:child_menu_item_2) { create :no_cms_menus_menu_item, menu_action: menu_action, menu: menu, parent: root_menu_item_2 }
    let(:draft_child_menu_item_2) { create :no_cms_menus_menu_item, menu_action: menu_action, menu: menu, parent: root_menu_item_2, draft: true }
    let(:root_menu_item_3) { create :no_cms_menus_menu_item, menu_action: menu_action, menu: menu }
    let(:only_draft_child_menu_item_3) { create :no_cms_menus_menu_item, menu_action: menu_action, menu: menu, parent: root_menu_item_3, draft: true }

    before do
      root_leaf_menu_item
      root_menu_item_1
      child_menu_item_1
      root_menu_item_2
      child_menu_item_2
      draft_child_menu_item_2
      root_menu_item_3
      only_draft_child_menu_item_3
    end

    context "when considering a root without children" do
      it "should be a leaf" do
        expect(root_leaf_menu_item.reload).to be_leaf_with_draft
      end
    end

    context "when considering a root with children" do
      it "should not be a leaf" do
        expect(root_menu_item_1.reload).to_not be_leaf_with_draft
      end
    end

    context "when considering a child without children" do
      it "should be a leaf" do
        expect(child_menu_item_1.reload).to be_leaf_with_draft
      end
    end

    context "when considering a root with some draft children" do
      it "should not be a leaf" do
        expect(root_menu_item_2.reload).to_not be_leaf_with_draft
      end

      context "when the other child is also drafted" do
        before { child_menu_item_2.update_attributes draft: true }
        it "should be a leaf" do
          expect(root_menu_item_2.reload).to be_leaf_with_draft
        end
      end
    end

    context "when considering a root with only draft children" do
      it "should be a leaf" do
        expect(root_menu_item_3.reload).to be_leaf_with_draft
      end

      context "when the children are undrafted" do
        before { only_draft_child_menu_item_3.update_attributes draft: false }
        it "should not be a leaf" do
          expect(root_menu_item_3.reload).to_not be_leaf_with_draft
        end
      end
    end

    context "whan searching this leaves with draft" do
      it "should detect the leaves" do
        expect(NoCms::Menus::MenuItem.leaves_with_draft).to match_array([root_leaf_menu_item, child_menu_item_1, child_menu_item_2, root_menu_item_3])
      end
    end
  end


end
