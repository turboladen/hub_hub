FactoryGirl.define do
  factory :post do
    title { Faker::HipsterIpsum.words(rand(2..5)).join(' ') }
    body { Faker::HipsterIpsum.sentences.join('.  ') }
    cached_votes_total 1
    cached_votes_up 1
    cached_votes_down 1

    after :build do |post|
      post.spoke = FactoryGirl.build :spoke
    end

    trait :with_spoke do
      spoke { Spoke.last || FactoryGirl.create(:spoke) }
    end
  end
end
