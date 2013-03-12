require 'test_helper'


class DigestEmailingTest < ActionDispatch::IntegrationTest
  fixtures :all
  include HubHelpers

  test 'changing user preference updates the user in the db' do
    pending 'turning the settings back on'
  end

  test 'sign up for and receive digest email' do
    ricky = login :ricky
    ricky.get edit_user_registration_path
    ricky.assert_response :success

    user = User.find(users(:ricky))
    assert !user.digest_email

    ricky.put user_registration_path, user: { digest_email: true }
    ricky.assert_redirected_to home_path

    user = User.find(users(:ricky))
    assert user.digest_email

    digest_user_count = User.digest_list.count
    assert_operator digest_user_count, :>, 0
    assert_difference('ActionMailer::Base.deliveries.size', digest_user_count) do
      DigestMailer.nightly_email_everyone
    end
  end

  test 'opt out of digest email' do
    original_digest_user_count = User.digest_list.count

    bob = login :bob
    bob.get edit_user_registration_path
    bob.assert_response :success

    user = User.find(users(:bob))
    assert user.digest_email

    bob.put user_registration_path, user: { digest_email: false }
    bob.assert_redirected_to home_path

    user = User.find(users(:bob))
    assert !user.digest_email

    updated_digest_user_count = User.digest_list.count
    assert_equal original_digest_user_count - 1, updated_digest_user_count

    assert_difference('ActionMailer::Base.deliveries.size', updated_digest_user_count) do
      DigestMailer.nightly_email_everyone
    end

    assert(ActionMailer::Base.deliveries.none? { |m| m.to == 'bob@bobo.com' })
  end
end
