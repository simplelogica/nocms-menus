FactoryGirl.define do
  factory :page, class: Page do
    name { Faker::Lorem.sentence }
  end
end
