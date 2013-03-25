require 'spec_helper'


describe Comment do
  fixtures :comments
  fixtures :posts
  fixtures :users

  describe '#initialize' do
    describe 'body' do
      it 'must not be blank' do
        expect(Comment.new).to have(1).errors_on(:body)
        expect(Comment.new.errors_on(:body)).to include "can't be blank"
      end
    end

    describe 'user' do
      it 'must not be blank' do
        expect(Comment.new).to have(1).errors_on(:user)
        expect(Comment.new.errors_on(:user)).to include "can't be blank"
      end
    end
  end

  describe '.last_24_hours' do
    it 'gets posts from last 24 hours' do
      retrieved_comments = Comment.last_24_hours
      retrieved_comments.size.should == 12
      retrieved_comments.should include comments(:comment_two_0)
      retrieved_comments.should include comments(:comment_two_1)
      retrieved_comments.should include comments(:comment_two_2)
      retrieved_comments.should include comments(:comment_two_3)
      retrieved_comments.should include comments(:comment_two_4)
      retrieved_comments.should include comments(:comment_two_5)
      retrieved_comments.should include comments(:comment_two_6)
      retrieved_comments.should include comments(:comment_two_7)
      retrieved_comments.should include comments(:comment_two_8)
      retrieved_comments.should include comments(:comment_two_9)
      retrieved_comments.should include comments(:comment_three_0)
      retrieved_comments.should include comments(:comment_three_1)
    end
  end

  describe '.find_comments_by_user' do
    it 'finds all comments for by a user' do
      comments = Comment.find_comments_by_user(users(:ricky))
      comments.should == [
        comments(:comment_three_1), comments(:comment_three_0)
      ]
    end
  end

  describe '.find_comments_by_commentable' do
    it 'finds all comments for by an item that was commented on' do
      comments = Comment.find_comments_by_commentable('Post', posts(:post_one).id)
      comments.should == [comments(:comment_one)]
    end
  end

  describe '.find_commentable' do
    it 'finds all comments for by an item that was commented on' do
      post = Comment.find_commentable('Post', posts(:post_one).id)
      post.should == [posts(:post_one)]
    end
  end

  describe '#post' do
    it 'gets the post the comment is part of' do
      comments(:comment_one).post.should == posts(:post_one)
    end
  end

  describe '#has_children?' do
    context 'has children' do
      let(:post) { posts(:post_one) }

      let(:parent_comment) do
        Comment.build_from(post, users(:ricky).id, 'a parent comment')
      end

      let(:child_comment) do
        Comment.build_from(post, users(:ricky).id, 'a parent comment')
      end

      before do
        parent_comment.save!
        child_comment.save!
        child_comment.move_to_child_of parent_comment
      end

      specify { parent_comment.should have_children }
    end
  end

  describe '#item_type' do
    specify { subject.item_type == 'comment' }
  end

  context 'commenting' do
    let(:post) { posts(:post_one) }

    let(:parent_comment) do
      Comment.build_from(post, users(:ricky).id, 'a parent comment')
    end

    let(:child_comment) do
      Comment.build_from(post, users(:ricky).id, 'a parent comment')
    end

    before do
      parent_comment.save!
    end

    it 'can be commented on' do
      expect {
        child_comment.save!
        child_comment.move_to_child_of parent_comment
      }.to change { parent_comment.children.size }.by 1

      parent_comment.should have_children
      child_comment.should_not have_children
    end
  end

  context 'voting' do
    let(:comment) { comments(:comment_one) }

    it 'can be upvoted/downvoted' do
      Comment.should be_votable

      expect {
        comment.upvote_from users(:bob)
      }.to change { comment.votes.up.size }.by 1

      expect {
        comment.downvote_from users(:bob)
      }.to change { comment.votes.down.size }.by 1
    end
  end


  context 'flagging' do
    let(:comment) { comments(:comment_one) }
    let(:user) { users(:bob) }

    context 'inappropriate' do
      it 'can be flagged/unflagged' do
        expect {
          user.flag(comment, :inappropriate)
        }.to change { comment.flaggings.with_flag(:inappropriate).size }.by 1

        expect {
          user.unflag(comment, :inappropriate)
        }.to change { comment.flaggings.with_flag(:inappropriate).size }.by -1
      end
    end
  end
end
