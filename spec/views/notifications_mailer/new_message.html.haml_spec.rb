require 'spec_helper'


describe 'notifications_mailer/new_message.html.haml' do
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

    rendered.should == <<-HTML
<p>Hi there,</p>
<p>These are some things that I'm saying.</p>

<p>And here are some other things.
</p>
<p>
Regards,
<br>
The MindHub Admins
</br>
</p>
    HTML
  end
end
