require 'spec_helper'


describe User do
  fixtures :users
  fixtures :posts
  fixtures :comments

  let(:bob) { users(:bob) }

  describe '#initialize' do
    it 'does not create an admin by default' do
      User.new.admin?.should be_false
    end

    it 'does not set digest_email by default' do
      User.new.digest_email.should be_false
    end

    describe 'first_name' do
      it 'must not be empty' do
        expect(User.new).to have(1).error_on(:first_name)
        expect(User.new.errors_on(:first_name)).to include("can't be blank")
      end
    end

    describe 'last_name' do
      it 'must not be empty' do
        expect(User.new).to have(1).error_on(:last_name)
        expect(User.new.errors_on(:last_name)).to include("can't be blank")
      end
    end

  end

  describe '.digest_list' do
    it 'gets email and name for users with digest_email set' do
      User.digest_list.map(&:attributes).should == [
        {
          'email' => users(:admin).email,
          'digest_email' => users(:admin).digest_email,
          'first_name' => users(:admin).first_name,
          'last_name' => users(:admin).last_name
        }, {
        'email' => users(:johnny).email,
        'digest_email' => users(:johnny).digest_email,
        'first_name' => users(:johnny).first_name,
        'last_name' => users(:johnny).last_name
        }, {
          'email' => bob.email,
          'digest_email' => bob.digest_email,
          'first_name' => bob.first_name,
          'last_name' => bob.last_name
        }
      ]
    end
  end

  describe '.admin_emails' do
    let(:admin) { users(:admin) }
    let(:su) { users(:super_user) }

    it 'gets all email address for admin users' do
      User.admin_emails.should == [admin.email, su.email]
    end
  end

  describe '.super_user' do
    it 'gets the super user' do
      User.super_user.should == users(:super_user)
    end
  end

  describe '#name' do
    it 'returns the first and last name' do
      bob.name.should == 'Bob Uecker'
    end
  end

  describe '#super_user?' do
    context 'user is the super user' do
      specify { users(:super_user).super_user?.should be_true }
    end

    context 'user is not the super user' do
      specify { users(:admin).super_user?.should be_false }
      specify { bob.super_user?.should be_false }
    end
  end

  context 'voting' do
    it 'can upvote/downvote a post' do
      bob.vote_up_for(posts(:post_one)).should be_true
      bob.vote_down_for(posts(:post_one)).should be_true
    end

    it 'can upvote/downvote a comment' do
      bob.vote_up_for(comments(:comment_one)).should be_true
      bob.vote_down_for(comments(:comment_one)).should be_true
    end
  end

  context 'flagging' do
    let(:post) { posts(:post_one) }
    let(:comment) { comments(:comment_one) }

    it 'can flag/unflag a post' do
      bob.flagged?(post).should be_false

      expect {
        bob.flag(post, :inappropriate).should be_true
        bob.flagged?(post).should be_true
      }.to change { post.flaggings.count }.by 1

      bob.unflag(post, :inappropriate).should be_true
      bob.flagged?(post).should be_false
    end

    it 'can flag/unflag a comment' do
      bob.flagged?(comment).should be_false

      expect {
        bob.flag(comment, :inappropriate).should be_true
        bob.flagged?(comment).should be_true
      }.to change { comment.flaggings.count }.by 1

      bob.unflag(comment, :inappropriate).should be_true
      bob.flagged?(comment).should be_false
    end
  end

  context 'banning' do
    it 'can be banned' do
      bob.should_not be_banned

      bob.banned = true
      bob.save!
      bob.should be_banned
    end
  end
end
