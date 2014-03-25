FactoryGirl.define do
  factory :no_cms_menus_menu, class: NoCms::Menus::Menu do
    uid { Faker::Lorem.sentence.parameterize }
    name { Faker::Lorem.sentence }
  end
end
