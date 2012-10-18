require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @bob = users(:bob)
  end

  test "#name returns the first_name and last_name as a String" do
    assert_equal(@bob.name, "Bob Uecker")
  end

  test "user is not admin by default" do
    assert_equal(@bob.admin?, false)
  end

  test "user can be banned" do
    assert_equal(@bob.banned?, false)

    @bob.banned = true
    @bob.save!
    assert_equal @bob.banned?, true
  end

  test "can vote" do
    assert @bob.vote_up_for posts(:post_one)
    assert @bob.vote_down_for comments(:comment_one)
  end

  test "can flag" do
    comment = comments(:comment_one)
    assert !@bob.flagged?(comment)

    assert_difference 'comment.flaggings.count' do
      @bob.flag comment, :inappropriate
    end

    assert @bob.flagged? comment
  end

  test "digest email is false by default" do
    user = User.create(email: 'test@test.com', password: 'password',
      password_confirmation: 'password')

    assert_equal "false", user.digest_email
  end
end
