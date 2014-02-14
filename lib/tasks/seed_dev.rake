namespace :db do
  desc 'Seeds the DB with test data'
  task seed_dev: :environment do
    user_count = 20
    spoke_count = 10
    post_count = 300
    response_count = post_count * 5

    User.transaction do
      (user_count - User.count).times do |i|
        factory = (i % 7).zero? ? %i[user banned] : %i[user]
        FactoryGirl.create(*factory)
      end
    end

    user_ids = User.pluck :id

    Spoke.transaction do
      (spoke_count - Spoke.count).times do
        spoke = FactoryGirl.create(:spoke, :full)
        puts "Created spoke: #{spoke.name}"
      end
    end

    spoke_ids = Spoke.pluck :id

    Post.transaction do
      (post_count - Post.count).times do
        spoke = Spoke.find(spoke_ids.sample)
        puts "spoke: #{spoke.name}"

        user = User.find(user_ids.sample)
        puts "user: #{user.email}"

        post = FactoryGirl.create(:post, spoke: spoke, owner: user)
        puts "created post: #{post.title}"
      end
    end

    post_ids = Post.pluck :id
    response_ids = Response.pluck :id

    Response.transaction do
      (response_count - Response.count).times do |i|
        respondable = if (i % 5).zero?
          post = Post.find(post_ids.sample)
          puts "post: #{post.title}"

          post
        else
          id = response_ids.sample || next
          response = Response.find(id)
          puts "response: #{response.id}"

          response
        end

        user = User.find(user_ids.sample)
        puts "user: #{user.email}"

        response = FactoryGirl.create(:response, respondable: respondable,
          owner: user)
        response_ids << response.id
        puts "created response to a: #{response.respondable_type}"
      end
    end
  end
end
