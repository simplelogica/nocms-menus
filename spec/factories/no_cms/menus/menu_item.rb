FactoryGirl.define do
  factory :no_cms_menus_menu_item, class: NoCms::Menus::MenuItem do
    name { Faker::Lorem.sentence }
    kind { 'fixed_url' }
  end
end
