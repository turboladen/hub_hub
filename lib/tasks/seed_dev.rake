namespace :db do
  desc 'Seeds the DB with test data'
  task seed_dev: :environment do
    user_count = 20
    spoke_count = 10
    post_count = 300

    User.transaction do
      (user_count - User.count).times do |i|
        factory = (i % 7).zero? ? %i[user banned] : %i[user]
        FactoryGirl.create(*factory)
      end
    end

    Spoke.transaction do
      (spoke_count - Spoke.count).times do
        spoke = FactoryGirl.create(:spoke, :full)
        puts "Created spoke: #{spoke.name}"
      end
    end

    Post.transaction do
      (post_count - Post.count).times do
        spoke_ids = Spoke.pluck :id
        spoke = Spoke.find(spoke_ids.sample)
        puts "spoke: #{spoke.name}"

        user_ids = User.pluck :id
        user = User.find(user_ids.sample)
        puts "user: #{user.email}"

        post = FactoryGirl.create(:post, spoke: spoke, user: user)
        puts "created post: #{post.title}"
      end
    end
  end
end
