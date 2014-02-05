FactoryGirl.define do
  factory :response do
    body { Faker::BaconIpsum.sentences.join('.  ') }
    respondable { association(:post) }
    owner
    created_at Time.now
    updated_at Time.now

    trait :to_a_response do
      respondable { association(:response) }
    end
  end
end
