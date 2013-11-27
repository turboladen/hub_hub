FactoryGirl.define do
  factory :post do
    title { Faker::HipsterIpsum.words(rand(2..5)).join(' ') }
    body { Faker::HipsterIpsum.sentences.join('.  ') }

    after :build do |post|
      post.spoke = FactoryGirl.build :spoke unless post.spoke
      post.owner = FactoryGirl.build :user unless post.owner
    end
  end
end
