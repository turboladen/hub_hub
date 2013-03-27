require 'spec_helper'


describe 'Signing up for and opting out of digest emails' do
  fixtures :all

  it 'lets a user sign up for and receive digest mail' do
    ricky = login :ricky
    ricky.get '/users/edit'
    ricky.response.code.should eq '200'

    user = User.find(users(:ricky))
    user.digest_email.should be_false

    ricky.put '/users', user: { digest_email: true }
    ricky.response.code.should == '302'

    user = User.find(users(:ricky))
    user.digest_email.should be_true

    digest_user_count = User.digest_list.count
    digest_user_count.should be > 0

    expect {
      DigestMailer.nightly_email_everyone
    }.to change { ActionMailer::Base.deliveries.size }.by digest_user_count
  end

  it 'lets a user opt out of digest emails' do
    original_digest_user_count = User.digest_list.count

    bob = login :bob
    bob.get '/users/edit'
    bob.response.code.should eq '200'

    user = User.find(users(:bob))
    user.digest_email.should be_true

    bob.put '/users', user: { digest_email: false }
    bob.response.code.should == '302'

    user = User.find(users(:bob))
    user.digest_email.should be_false

    updated_digest_user_count = User.digest_list.count
    updated_digest_user_count.should == original_digest_user_count - 1

    expect {
      DigestMailer.nightly_email_everyone
    }.to change { ActionMailer::Base.deliveries.size }.by updated_digest_user_count

    ActionMailer::Base.deliveries.none? { |m| m.to == 'bob@bobo.com' }.should be_true
  end
end
