require 'test_helper'


class PostMailerTest < ActionMailer::TestCase
  setup do
    spokes(:fresno)
    users(:bob)
    Post.any_instance.stubs(:tweet).returns(true)

    @content = <<-BODY
This is a post
Hi everyone.
    BODY

    @mail = Mail.new do
      from    'bob@bobo.com'
      to      'poster@test.net'
      subject 'Fresno: This is a test email'
    end
  end

  test "non-multipart email posts" do
    @mail.body = @content

    assert_difference('Post.count') do
      assert PostMailer.receive(@mail.to_s)
    end

    @content.each_line do |original_line|
      Post.last.content do |new_line|
        assert_match /#{new_line}/, original_line.strip
      end
    end
  end

  test "multipart email posts text part" do
    text_part = Mail::Part.new
    text_part.body = @content
    @mail.text_part = text_part
    @mail.html_part = Mail::Part.new do
      content_type 'text/html; charset=UTF-8'
      body '<h1>Sup!</h1>'
    end

    assert_difference('Post.count') do
      assert PostMailer.receive(@mail.to_s)
    end

    @content.each_line do |original_line|
      Post.last.content do |new_line|
        assert_match /#{new_line}/, original_line.strip
      end
    end
  end

  test "email with unknown spoke posts to the Chat spoke" do
    Spoke.create(name: 'Chat')
    @mail.subject = 'Some Spoke: This is a test email'
    @mail.body = 'Some stuff'

    chat_change = lambda do
      chat = Spoke.find_by_name('Chat')
      chat.posts.count
    end

    assert_difference(chat_change) do
      PostMailer.receive(@mail.to_s)
    end
  end

  test "email from unknown user doesn't post and doesn't raise" do
    @mail.body = @content
    @mail.from = 'someguy@anonymous.com'

    assert_no_difference('Post.count') do
      PostMailer.receive(@mail.to_s)
    end

    assert_nothing_raised do
      PostMailer.receive(@mail.to_s)
    end

    assert_difference('ActionMailer::Base.deliveries.size') do
      PostMailer.receive(@mail.to_s)
    end
  end

  test "email fails to save" do
    Post.any_instance.expects(:save).times(3).returns(false)
    @mail.body = @content

    assert_no_difference('Post.count') do
      PostMailer.receive(@mail.to_s)
    end

    assert_nothing_raised do
      PostMailer.receive(@mail.to_s)
    end

    assert_difference('ActionMailer::Base.deliveries.size') do
      PostMailer.receive(@mail.to_s)
    end
  end
end
