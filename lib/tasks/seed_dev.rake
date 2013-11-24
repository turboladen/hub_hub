namespace :db do
  desc 'Seeds the DB with test data'
  task seed_dev: :environment do
    User.transaction do
      (20 - User.count).times do |i|
        factory = (i % 7).zero? ? %i[user banned] : %i[user]
        FactoryGirl.create(*factory)
      end
    end

    Spoke.transaction do
      (10 - Spoke.count).times do
        spoke = FactoryGirl.create(:spoke, :full)
        puts "Created spoke: #{spoke.name}"
      end
    end

=begin
    Post.transaction do
      (300 - Post.count).times do
        FactoryGirl.create(:post, spoke: Spoke.take!, user: User.take!)
      end
    end
=end
  end
end
