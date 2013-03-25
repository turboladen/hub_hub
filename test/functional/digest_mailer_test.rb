require 'test_helper'


class DigestMailerTest < ActionMailer::TestCase
  setup do
    @bob = users(:bob)
    @admin = users(:admin)
  end

  test 'nightly email can send' do
    # Send the email, then test that it got queued
    test_subject = 'This is the subject'
    posts = []
    comments = []
    email = DigestMailer.nightly_email(@bob, test_subject, posts, comments).deliver
    assert !ActionMailer::Base.deliveries.empty?

    # Test the body of the sent email contains what we expect it to
    assert_equal [@bob.email], email.to
    assert_equal test_subject, email.subject
    assert_match(/Hi #{@bob.first_name},/, email.encoded)
    assert_not_match(/Hi #{@admin.first_name},/, email.encoded)

    email
  end

  test 'nightly email with no posts or comments' do
    # Not sure why posts and comments are loaded...
    Post.delete_all
    Comment.delete_all
    assert_equal 0, Post.count
    assert_equal 0, Comment.count

    email = test_nightly_email_can_send

    assert_match(/No posts from yesterday\./, email.encoded)
    assert_match(/No responses from yesterday\./, email.encoded)
  end

  test 'can send to all subscribers' do
    assert_difference('ActionMailer::Base.deliveries.count', 3) do
      DigestMailer.nightly_email_everyone
    end

    ActionMailer::Base.deliveries.each do |delivery|
      /Hi (?<name>[^,]+),/m =~ delivery.to_s
      assert_match(/#{name}/, delivery.to_s)
      wrong_names = User.digest_list.all.map(&:first_name) - [name]

      wrong_names.each do |wrong_name|
        assert_not_match(/#{wrong_name}/, delivery.to_s,
          "Found #{wrong_name} instead of #{wrong_name}")
      end
    end
  end
end
