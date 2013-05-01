require 'spec_helper'


describe PostMailer do
  fixtures :users
  fixtures :spokes

  let(:content) do
    <<-BODY
This is a post
Hi everyone.
    BODY
  end

  let(:mail) do
    Mail.new do
      from    'bob@bobo.com'
      to      'poster@test.net'
      subject 'Fresno: This is a test email'
    end
  end

  before do
    Post.any_instance.stub(:tweet).and_return true
  end

  describe '#receive' do
    context 'non-multipart emails' do
      it 'can receive and post' do
        mail.body = content
        expect { PostMailer.receive(mail.to_s) }.to change { Post.count }.by 1

        content.each_line do |original_line|
          Post.last.content do |new_line|
            original_line.strip.should include new_line
          end
        end
      end
    end

    context 'multipart emails' do
      it 'posts the text part of multipart emails' do
        text_part = Mail::Part.new
        text_part.body = content
        mail.text_part = text_part
        mail.html_part = Mail::Part.new do
          content_type 'text/html; charset=UTF-8'
          body '<h1>Sup!</h1>'
        end

        expect { PostMailer.receive(mail.to_s) }.to change { Post.count }.by 1

        content.each_line do |original_line|
          Post.last.content do |new_line|
            original_line.strip.should include new_line
          end
        end
      end
    end

    context 'unknown Spoke' do
      before do
        spokes(:chat)
        mail.subject = subject
        mail.body = 'Some stuff'
      end

      let(:subject) { 'Some Spoke: This is a test email' }

      it 'posts to Chat' do
        expect {
          PostMailer.receive(mail.to_s)
        }.to change { Spoke.find_by_name('Chat').posts.count }.by 1

        Post.find_by_title(subject).title.should == mail.subject
      end
    end

    context 'email from unknown user' do
      before do
        mail.body = content
        mail.from = 'someguy@anonymous.com'
      end

      it 'does not post, does not raise, and replies to the emailer' do
        expect { PostMailer.receive(mail.to_s) }.to_not change { Post.count }
        expect { PostMailer.receive(mail.to_s) }.to_not raise_exception
        expect {
          PostMailer.receive(mail.to_s)
        }.to change { ActionMailer::Base.deliveries.size }.by 1
      end
    end

    context 'email with no subject' do
      before do
        mail.body = content
        mail.subject = ''
      end

      it 'does not post, does not raise, and replies to the emailer' do
        expect { PostMailer.receive(mail.to_s) }.to_not change { Post.count }
        expect { PostMailer.receive(mail.to_s) }.to_not raise_exception
        expect {
          PostMailer.receive(mail.to_s)
        }.to change { ActionMailer::Base.deliveries.size }.by 1
      end
    end

    context 'email fails to save' do
      before do
        Post.any_instance.stub(:save).and_return false
        mail.body = content
      end

      it 'does not post, does not raise, and replies to the emailer' do
        expect { PostMailer.receive(mail.to_s) }.to_not change { Post.count }
        expect { PostMailer.receive(mail.to_s) }.to_not raise_exception
        expect {
          PostMailer.receive(mail.to_s)
        }.to change { ActionMailer::Base.deliveries.size }.by 1
      end
    end

    context 'email from old list server' do
      before do
        mail.header = 'Sender: "Mindhub-list" <mindhub-list-bounces@list.mindhub.org>'
        mail.body = content
        mail.subject = 'Some stuff!'
      end

      it 'posts to Chat as the list user' do
        expect {
          PostMailer.receive(mail.to_s)
        }.to change { Spoke.find_by_name('Chat').posts.count }.by 1

        post = Post.last
        post.title.should == mail.subject
        post.user.should == User.find_by_email('mindhub-list-bounces@list.mindhub.org')
      end
    end
  end
end
