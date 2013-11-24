FactoryGirl.define do
  factory :spoke do
    sequence(:name) do
      "Spoke #{Spoke.count + 1}"
    end

    trait :full do
      description { Faker::BaconIpsum.paragraphs.join("\n") }
    end
  end
end
