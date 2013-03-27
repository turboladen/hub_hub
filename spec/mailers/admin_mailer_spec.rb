require 'spec_helper'


describe AdminMailer do
  fixtures :users

  describe '#receive' do
    let(:admin1) { users(:admin) }
    let(:admin2) { users(:super_user) }

    let(:mail) do
      Mail.new do
        from    'bob@bobo.com'
        to      'admin@test.net'
        subject 'Hi admin peoples'
      end
    end

    before do
      mail.body = 'I like you'
    end

    context 'multipart email' do
      before do
        mail.html_part = Mail::Part.new do
          content_type 'text/html; charset=UTF-8'
          body '<p>I HTML like you</p>'
        end
      end

      it 'gets sent to all admin users as 1 email' do
        expect {
          AdminMailer.receive(mail.to_s)
        }.to change { ActionMailer::Base.deliveries.size }.by 1

        received_email = ActionMailer::Base.deliveries.first
        received_email.should be_multipart
        received_email.from.should == [users(:bob).email]
        received_email.to.should == [admin1.email, admin2.email]
        received_email.html_part.body.decoded.should include '<p>I HTML like you</p>'
        received_email.text_part.body.decoded.should include 'I like you'
      end
    end

    context 'non-multipart email' do
      it 'gets sent to all admin users as 1 email' do
        expect {
          AdminMailer.receive(mail.to_s)
        }.to change { ActionMailer::Base.deliveries.size }.by 1

        received_email = ActionMailer::Base.deliveries.first
        received_email.should_not be_multipart
        received_email.from.should == [users(:bob).email]
        received_email.to.should == [admin1.email, admin2.email]
        received_email.body.decoded.should == 'I like you'
      end
    end
  end
end
