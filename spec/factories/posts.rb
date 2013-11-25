FactoryGirl.define do
  factory :post do
    title { Faker::HipsterIpsum.words(rand(2..5)).join(' ') }
    body { Faker::HipsterIpsum.sentences.join('.  ') }

    after :build do |post|
      post.spoke = FactoryGirl.build :spoke unless post.spoke
      #post.user = FactoryGirl.build :user unless post.user
    end
  end
end
