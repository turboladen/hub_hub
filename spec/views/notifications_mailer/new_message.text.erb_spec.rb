require 'spec_helper'


describe 'notifications_mailer/new_message.text.erb' do
  let(:message) { double 'Message', body: body }

  let(:body) do
    <<-BODY
These are some things that I'm saying.

And here are some other things.
    BODY
  end

  before do
    assign(:message, message)
  end

  it 'renders the email body' do
    render

    rendered.should == <<-TEXT
Hi there,

These are some things that I'm saying.

And here are some other things.


Regards,

The MindHub Admins
    TEXT
  end
end
