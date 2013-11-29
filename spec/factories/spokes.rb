FactoryGirl.define do
  factory :spoke do
    sequence(:name) do
      "Spoke #{Spoke.count + 1}"
    end

    trait :full do
      description { Faker::BaconIpsum.sentence }
    end
  end
end
