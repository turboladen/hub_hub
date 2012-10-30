require 'test_helper'

class DigestMailerTest < ActionMailer::TestCase
  test "nightly email" do
    user = users(:bob)

    # Send the email, then test that it got queued
    email = DigestMailer.nightly_email(user).deliver
    assert !ActionMailer::Base.deliveries.empty?

    # Test the body of the sent email contains what we expect it to
    assert_equal [user.email], email.bcc
    assert_equal "Your mindhub.org digest for #{Date.today.to_formatted_s(:long)}",
      email.subject
    assert_match(/Hi #{user.first_name},/, email.encoded)
  end
end
