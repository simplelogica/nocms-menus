FactoryGirl.define do
  factory :no_cms_menus_menu_item, class: NoCms::Menus::MenuItem do
    name { Faker::Lorem.sentence }
    kind { 'fixed_url' }
    menu { FactoryGirl.create :no_cms_menus_menu }


    factory :no_cms_menus_menu_item_for_page, class: NoCms::Menus::MenuItem do
      kind { 'page' }
    end
  end
end
