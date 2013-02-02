require 'test_helper'


class PostMailerTest < ActionMailer::TestCase
  setup do
    spokes(:fresno)
    users(:bob)
    Post.any_instance.stubs(:tweet).returns(true)
  end

  test "non-multipart email posts" do
    mail = Mail.new do
      from    'bob@bobo.com'
      to      'poster@test.net'
      subject 'Fresno: This is a test email'
      body    'Simple body'
    end

    assert_difference('Post.count') do
      assert PostMailer.receive(mail.to_s)
    end
  end

  test "multipart email posts text part" do
    mail = Mail.new do
      from    'bob@bobo.com'
      to      'poster@test.net'
      subject 'Fresno: This is a test email'
      text_part do
        'Simple body'
      end

      html_part do
        "<h1>Sup!</h1>"
      end
    end

    assert_difference('Post.count') do
      assert PostMailer.receive(mail.to_s)
    end
  end

  test "email with unknown spoke name doesn't post and doesn't raise" do
    mail = Mail.new do
      from    'bob@bobo.com'
      to      'poster@test.net'
      subject 'Some Spoke: This is a test email'
      body    'Simple body'
    end

    assert_no_difference('Post.count') do
      PostMailer.receive(mail.to_s)
    end

    assert_nothing_raised do
      PostMailer.receive(mail.to_s)
    end
  end

  test "email from unknown user doesn't post and doesn't raise" do
    mail = Mail.new do
      from    'someguy@anonymous.com'
      to      'poster@test.net'
      subject 'Fresno: This is a test email'
      body    'Simple body'
    end

    assert_no_difference('Post.count') do
      PostMailer.receive(mail.to_s)
    end

    assert_nothing_raised do
      PostMailer.receive(mail.to_s)
    end
  end
end
