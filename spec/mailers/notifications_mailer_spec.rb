require 'spec_helper'


describe NotificationsMailer do
  fixtures :users

  let(:bob) do
    users(:bob)
  end

  describe '#new_message' do
    let(:message) do
      Message.new(name: bob.name, email: bob.email, subject: 'hi', body: 'bye')
    end

    subject { NotificationsMailer.new_message(message) }
    specify { subject.should be_a Mail::Message }
    specify { subject.from.should == %w[admin@mindhub.org] }

    specify do
      subject.bcc.should == %w[
        list-recipient@chat.mindhub.org
        karl.winslow@winslow.com
        ricky.ricardo@gmail.com
        john.jacob.jingleheimer-schmidt@gmail.com
        bob@bobo.com
      ]
    end

    specify do
      subject.cc.should == %w[
        admin@INTERNETZ.com
        admin@mindhub.org
      ]
    end
  end
end
