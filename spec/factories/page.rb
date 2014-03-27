FactoryGirl.define do
  factory :page, class: Page do
    name { Faker::Lorem.sentence.parameterize.gsub('-', ' ') }
  end
end
