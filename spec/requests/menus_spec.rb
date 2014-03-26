require 'spec_helper'

describe NoCms::Menus do

  context "when visiting a page with a menu item" do

    let(:the_page) { create :page }
    let(:menu_item) { create :no_cms_menus_menu_item, menu: menu, menuable: the_page }
    let(:menu) { create :no_cms_menus_menu, uid: 'test' }

    before do
      menu_item
      visit page_path the_page
    end

    subject { page }

    it "should mark that item as active" do
      expect(subject).to have_selector '.menu .menu_item.active', text: menu_item.name
    end

  end



end
