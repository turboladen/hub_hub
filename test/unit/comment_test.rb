require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  setup do
    @comment = comments(:comment_one)
    @user = users(:ricky)
  end

  test "comment attributes must not be empty" do
    comment = Comment.new
    assert comment.invalid?
    assert comment.errors[:body].any?
    assert comment.errors[:user].any?
  end

  test "must have a body" do
    comment = Comment.new
    comment.user = users(:bob)

    assert !comment.save
    assert comment.invalid?
    assert_equal "can't be blank", comment.errors[:body].join("; ")

    comment.body = "This is my body"
    assert comment.save
    assert comment.valid?
    assert !comment.errors[:body].any?
  end

  test "must have a user" do
    comment = Comment.new
    comment.body = "This is my body"

    assert !comment.save
    assert comment.invalid?
    assert_equal "can't be blank", comment.errors[:user].join("; ")

    comment.user = users(:ricky)
    assert comment.save
    assert comment.valid?
    assert !comment.errors[:user].any?
  end

  test "is votable" do
    assert Comment.votable?
  end

  test "is commentable" do
    post = posts(:post_one)
    parent_comment = Comment.build_from(post, users(:ricky).id, "a parent comment")
    child_comment = Comment.build_from(post, users(:ricky).id, "a child comment")

    assert parent_comment.save
    assert child_comment.save
    assert child_comment.move_to_child_of(parent_comment)

    assert parent_comment.has_children?
    assert !child_comment.has_children?
  end

  test "is flaggable as inappropriate" do
    assert !@comment.flagged?

    assert_raise MakeFlaggable::Exceptions::InvalidFlagError do
      @user.flag @comment, :blah
    end

    assert_difference '@comment.flaggings.count' do
      @user.flag @comment, :inappropriate
    end

    assert @comment.flagged?
  end

  test "is related to a Post" do
    assert_equal posts(:post_one), comments(:comment_one).post
  end

  test "get comments from last 24 hours" do
    assert_equal 2, Comment.last_24_hours.count
    assert_not_include Comment.last_24_hours, @comment
  end
end
