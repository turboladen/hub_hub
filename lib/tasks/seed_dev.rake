namespace :db do
  desc 'Seeds the DB with test data'
  task seed_dev: :environment do
    User.transaction do
      (20 - User.count).times do |i|
        factory = (i % 7).zero? ? %i[user banned] : %i[user]
        FactoryGirl.create(*factory)
      end
    end

    Post.transaction do
      (300 - Post.count).times do
        FactoryGirl.create(:post, user: User.take!)
      end
    end
  end
end
