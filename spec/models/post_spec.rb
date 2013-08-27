require 'spec_helper'


describe Post do
  fixtures :posts
  fixtures :spokes
  fixtures :users

  describe '#initialize' do
    describe 'title' do
      it 'must not be blank' do
        expect(Post.new).to have(2).errors_on(:title)
        expect(Post.new.errors_on(:title)).to include "can't be blank"
        expect(Post.new.errors_on(:title)).to include 'is too short (minimum is 2 characters)'
      end

      it 'must be greater than 1 chars' do
        expect(Post.new(title: 'a')).to have(1).errors_on(:title)
        expect(Post.new(title: 'a').
          errors_on(:title)).to include 'is too short (minimum is 2 characters)'
      end

      it 'must be shorter than 101 chars' do
        title = 'a' * 101
        expect(Post.new(title: title)).to have(1).errors_on(:title)
        expect(Post.new(title: title).
          errors_on(:title)).to include 'is too long (maximum is 100 characters)'
      end
    end

    describe 'content' do
      it 'must not be blank' do
        expect(Post.new).to have(1).error_on(:content)
        expect(Post.new.errors_on(:content)).to include "can't be blank"
      end

      it 'must not be longer than 4000 chars' do
        ok_content = 'a' * 4000
        long_content = 'a' * 4001

        expect(Post.new(content: ok_content)).to have(0).errors_on(:content)
        expect(Post.new(content: long_content)).to have(1).errors_on(:content)
        expect(Post.new(content: long_content).
          errors_on(:content)).to include 'is too long (maximum is 4000 characters)'
      end
    end

    describe 'spoke' do
      it 'must be associated to the post' do
        expect(Post.new).to have(1).error_on(:spoke_id)
        expect(Post.new.errors_on(:spoke_id)).to include "can't be blank"
      end
    end
  end

  describe '.newest' do
    it 'sorts posts from newest to oldest' do
      Post.newest.should == [
        posts(:link_post_one),
        posts(:post_five),
        posts(:post_four),
        posts(:post_three),
        posts(:post_two),
        posts(:post_one)
      ]
    end
  end

  describe '.most_active' do
    it 'sorts posts from most comments to least, excluding posts with no comments' do
      Post.most_active.should == [
        posts(:post_two),
        posts(:post_three),
        posts(:post_one),
      ]
    end
  end

  describe '.most_negative' do
    it 'sorts posts from most negative votes to least, excluding posts with no negative votes' do
      Post.most_negative.should == [
        posts(:post_three),
        posts(:post_two),
        posts(:post_four),
      ]
    end
  end

  describe '.most_positive' do
    it 'sorts posts from most positive votes to least, excluding posts with no positive votes' do
      Post.most_positive.should == [
        posts(:post_one),
        posts(:post_two),
        posts(:post_four),
      ]
    end
  end

  describe '.most_voted' do
    it 'sorts posts from most total votes to least, excluding posts with no votes' do
      Post.most_voted.should == [
        posts(:post_two),
        posts(:post_three),
        posts(:post_one),
        posts(:post_four),
      ]
    end
  end

  describe '.last_24_hours' do
    it 'gets posts from last 24 hours' do
      posts = Post.last_24_hours
      posts.size.should == 5
      posts.should == [
        posts(:post_two),
        posts(:post_three),
        posts(:post_four),
        posts(:link_post_one),
        posts(:post_five),
      ]
    end
  end

  describe '.sort_options' do
    specify do
      Post.sort_options.should == %w[
        newest most_active most_positive most_negative most_voted
      ]
    end
  end

  describe '#save' do
    context 'success' do
      let(:post) do
        p = Post.new(title: 'test', content: 'test')
        p.spoke_id = spokes(:fresno).id

        p
      end

      it 'tweets the post' do
        post.should_receive(:tweet)
        post.save!
      end
    end

    context 'failure' do
      let(:post) do
        Post.new(title: 'test', content: 'test')
      end

      it 'does not tweet the post' do
        post.should_not_receive(:tweet)
        post.save
      end
    end
  end

  describe '#link?' do
    context 'not a link' do
      specify { posts(:post_one).should_not be_a_link }
    end

    context 'is a link' do
      specify { posts(:link_post_one).should be_a_link }
    end
  end

  describe '#item_type' do
    specify { posts(:post_one).item_type.should == 'post' }
  end

  describe '#tweet' do
    let(:post) { posts(:post_one) }

    before do
      Rails.stub_chain(:env, :production?).and_return true
      include ActionView::Helpers::UrlHelper
      subject.url_options[:host] = 'example.com'
    end

    context 'post is not persisted' do
      it 'does not tweet' do
        Twitter.should_not_receive(:update)
        Post.new.tweet
      end
    end

    context 'post is not persisted' do
      it 'tweets a link to the post' do
        url = "http://chat.mindhub.org/spokes/#{post.spoke.id}/posts/#{post.id}"

        Twitter.should_receive(:update).
          with %Q{#{post.spoke.name}: #{post.title} #{url}}
        post.tweet
      end
    end
  end

  context 'commenting' do
    let(:post) { posts(:post_one) }
    let(:user) { users(:bob) }

    it 'can be commented on' do
      expect {
        Comment.build_from(post, user.id, 'This is a comment').save!
      }.to change { post.root_comments.size }.by 1
    end
  end

  context 'voting' do
    let(:post) { posts(:post_one) }

    it 'can be upvoted/downvoted' do
      Post.should be_votable

      expect {
        post.upvote_from users(:bob)
      }.to change { post.votes.up.size }.by 1

      expect {
        post.downvote_from users(:bob)
      }.to change { post.votes.down.size }.by 1
    end
  end

  context 'flagging' do
    let(:post) { posts(:post_one) }
    let(:user) { users(:bob) }

    context 'inappropriate' do
      it 'can be flagged/unflagged' do
        expect {
          user.flag(post, :inappropriate)
        }.to change { post.flaggings.with_flag(:inappropriate).size }.by 1

        expect {
          user.unflag(post, :inappropriate)
        }.to change { post.flaggings.with_flag(:inappropriate).size }.by -1
      end
    end

    context 'favorite' do
      it 'can be flagged/unflagged' do
        expect {
          user.flag(post, :favorite)
        }.to change { post.flaggings.with_flag(:favorite).size }.by 1

        expect {
          user.unflag(post, :favorite)
        }.to change { post.flaggings.with_flag(:favorite).size }.by -1
      end
    end
  end
end
