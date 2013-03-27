require 'spec_helper'


describe DigestMailer do
  fixtures :users
  fixtures :posts
  fixtures :comments
  fixtures :spokes

  describe '.nightly_email_everyone' do
    it 'emails everyone in the User.digest_list' do
      User.digest_list.size.should == 3

      expect {
        DigestMailer.nightly_email_everyone
      }.to change { ActionMailer::Base.deliveries.count }.by 3
    end

    it 'sends addresses each email to the user by their name' do
      DigestMailer.nightly_email_everyone

      ActionMailer::Base.deliveries.each do |delivery|
        /Hi (?<name>[^,]+),/m =~ delivery.to_s
        delivery.to_s.should match /#{name}/
      end
    end

    it 'does not send to non-digest users' do
      ActionMailer::Base.deliveries.each do |delivery|
        /Hi (?<name>[^,]+),/m =~ delivery.to_s
        wrong_names = User.digest_list.all.map(&:first_name) - [name]

        wrong_names.each do |wrong_name|
          delivery.to_s.should_not include wrong_name
        end
      end
    end
  end

  describe '#nightly_email' do
    let(:user) { users(:bob) }
    let(:super_user) { users(:super_user) }
    let(:test_subject) { 'This is the subject' }

    context 'with posts and comments' do
      let(:posts) { Post.all }
      let(:comments) { Comment.all }

      it 'sends an email' do
        email = nil

        expect {
          email = DigestMailer.nightly_email(user, test_subject, posts, comments)
        }.to change { ActionMailer::Base.deliveries.size }.by 1

        email.to.should == [user.email]
        email.subject.should == test_subject
        email.encoded.should include "Hi #{user.first_name}"
        email.encoded.should_not include "Hi #{super_user.first_name}"

        email.encoded.should_not include 'No posts from yesterday.'
        email.encoded.should_not include 'No posts from yesterday.'
      end
    end

    context 'no posts or comments' do
      let(:posts) { [] }
      let(:comments) { [] }

      it 'sends an email' do
        email = nil

        expect {
          email = DigestMailer.nightly_email(user, test_subject, posts, comments)
        }.to change { ActionMailer::Base.deliveries.size }.by 1

        email.encoded.should include 'No posts from yesterday.'
        email.encoded.should include 'No posts from yesterday.'
      end
    end
  end
end
