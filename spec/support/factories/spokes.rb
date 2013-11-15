FactoryGirl.define do
  factory :spoke do
    name { Faker::BaconIpsum.word }

    trait :full do
      description { Faker::BaconIpsum.paragraphs.join("\n") }
    end
  end
end
