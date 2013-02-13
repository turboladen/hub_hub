require 'test_helper'

class AdminMailerTest < ActionMailer::TestCase
  setup do
    @admin1 = users(:admin)
    @admin2 = users(:super_user)
    users(:bob)

    @mail = Mail.new do
      from    'bob@bobo.com'
      to      'admin@test.net'
      subject 'Hi admin peoples'
    end
  end

  test "non-multipart email received gets sent to all admin users" do
    @mail.body = 'I like you'

    assert_difference('ActionMailer::Base.deliveries.size') do
      AdminMailer.receive(@mail.to_s)
    end

    assert !ActionMailer::Base.deliveries.first.multipart?
    assert_equal ['bob@bobo.com'], ActionMailer::Base.deliveries.first.from
    assert_equal [@admin1.email, @admin2.email],
      ActionMailer::Base.deliveries.first.to
    assert_equal "I like you",
      ActionMailer::Base.deliveries.first.body.decoded
  end

  test "multipart email received gets sent to all admin users" do
    @mail.text_part = Mail::Part.new do
      body "I like you"
    end

    @mail.html_part = Mail::Part.new do
      content_type 'text/html; charset=UTF-8'
      body "<p>I like you</p>"
    end

    assert_difference('ActionMailer::Base.deliveries.size') do
      assert AdminMailer.receive(@mail.to_s)
    end

    assert ActionMailer::Base.deliveries.first.multipart?
    assert_equal ['bob@bobo.com'], ActionMailer::Base.deliveries.first.from
    assert_equal [@admin1.email, @admin2.email],
      ActionMailer::Base.deliveries.first.to
    assert_equal "<p>I like you</p>",
      ActionMailer::Base.deliveries.first.html_part.body.decoded
    assert_equal "I like you",
      ActionMailer::Base.deliveries.first.text_part.body.decoded
  end
end
