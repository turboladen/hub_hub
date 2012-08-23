require 'test_helper'

class PostTest < ActiveSupport::TestCase
  setup do
    @one = posts(:one)
    @two = posts(:two)
    @three = posts(:three)
    @four = posts(:four)
    @five = posts(:five)
  end

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

  test "#most_active returns only posts with comments" do
    assert !Post.most_active.include?(@four)
    assert !Post.most_active.include?(@five)
  end

  test "#most_active returns posts ordered by comment count" do
    assert_equal Post.most_active, [@two, @three, @one]
  end

  test "#most_negative returns only posts with downvotes" do
    assert !Post.most_negative.include?(@one)
    assert !Post.most_negative.include?(@five)
  end

  test "#most_negative returns posts ordered by downvotes" do
    assert_equal Post.most_negative, [@three, @two, @four]
  end

  test "#most_positive returns only posts with upvotes" do
    assert !Post.most_positive.include?(@three)
    assert !Post.most_positive.include?(@five)
  end

  test "#most_positive returns posts ordered by upvotes" do
    assert_equal Post.most_positive, [@one, @two, @four]
  end

  test "#most_voted returns only posts with votes" do
    assert !Post.most_voted.include?(@five)
  end

  test "#most_voted returns posts ordered by total votes" do
    assert_equal Post.most_voted, [@two, @three, @one, @four]
  end
end
