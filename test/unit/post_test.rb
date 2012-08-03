require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "post attributes must not be empty" do
    post = Post.new
    assert post.invalid?
    assert post.errors[:title].any?
    assert post.errors[:content].any?
  end

  test "title can't be longer than 100 chars" do
    post = Post.new(content: "content", title: "1" * 100)
    assert post.save
    assert post.errors[:title].empty?

    post = Post.new(content: "content", title: "1" * 101)
    assert !post.save
    assert_equal "is too long (maximum is 100 characters)", post.errors[:title].join('; ')
  end

  test "content can't be longer than 4000 chars" do
    post = Post.new(content: "c" * 4000, title: "1")
    assert post.save
    assert post.errors[:content].empty?

    post = Post.new(content: "c" * 4001, title: "1")
    assert !post.save
    assert_equal "is too long (maximum is 4000 characters)", post.errors[:content].join('; ')
  end
end
