require 'ffaker'
require_relative '../config/boot'
require_relative '../config/application'
require_relative '../config/environment'


#Rake::Task["db:reset"].invoke
Rake::Task['db:setup'].invoke
Rake::Task['db:seed'].invoke

20.times do
  User.create!({
    email: Faker::Internet.email,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    password: 'password',
    password_confirmation: 'password',
    remember_me: false
  })
end

users = User.all
lorem = Faker::Lorem


#-------------------------------------------------------------------------------
# Event
#-------------------------------------------------------------------------------
spokes = Spoke.all

300.times do
  spoke = spokes.sample
  post = spoke.posts.build(title: lorem.sentence, content: lorem.paragraphs)
  post.user = users.sample
  post.save!
  puts "[#{spoke.name}] created post: #{post.title}"

  20.times do |i|
    parent_comment = Comment.build_from(post, users.sample.id, Faker::Lorem.paragraph)
    parent_comment.save!

    nested_comment = Comment.build_from(post, users.sample.id, Faker::Lorem.paragraph)
    nested_comment.save!
    nested_comment.move_to_child_of(parent_comment)

    if i % 4
      nested_comment2 = Comment.build_from(post, users.sample.id, Faker::Lorem.paragraph)
      nested_comment2.save!
      nested_comment2.move_to_child_of(nested_comment)
    end
  end

  12.times do
    post.liked_by users.sample
  end

  4.times do
    post.disliked_by users.sample
  end

  8.times do
    users.sample.toggle_flag(post, :inappropriate)
    users.sample.toggle_flag(post, :favorite)
  end
end

