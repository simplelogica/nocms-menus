FactoryGirl.define do
  factory :product, class: Product do
    name { Faker::Lorem.sentence }
  end
end
