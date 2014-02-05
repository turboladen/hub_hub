FactoryGirl.define do
  factory :post do
    title { Faker::HipsterIpsum.words(rand(2..5)).join(' ') }
    body { Faker::HipsterIpsum.sentences.join('.  ') }
    owner
    spoke
    created_at Time.now
    updated_at Time.now
  end
end
