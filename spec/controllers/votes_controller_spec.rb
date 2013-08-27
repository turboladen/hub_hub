require 'spec_helper'


describe VotesController do
  fixtures :comments
  fixtures :posts
  fixtures :users

  let(:comment) { comments(:comment_one) }
  let(:post_one) { posts(:post_one) }

  describe '#upvote' do
    context 'user not logged in' do
      it 'returns a 401' do
        expect {
          xhr :post, :upvote, {
            item_type: :comment,
            item_id: comment.id
          }
        }.to_not change { comment.votes.size }

        response.code.should eq '401'
      end
    end

    context 'user logged in' do
      before do
        sign_in users(:bob)
      end

      context 'comment not already voted on' do
        it 'adds a vote' do
          expect {
            xhr :post, :upvote, {
              item_type: :comment,
              item_id: comment.id
            }
          }.to change { comment.likes.size }.by 1

          assigns(:item_type).should == Comment
          assigns(:item).should == comment
          assigns(:upvote_count).should == '1'
          assigns(:downvote_count).should == '0'
          assigns(:total_vote_count).should == '1'

          response.code.should eq '200'
        end
      end

      context 'comment already voted on' do
        before do
          comment.liked_by users(:bob)
        end

        it 'removes a vote' do
          expect {
            xhr :post, :upvote, {
              item_type: :comment,
              item_id: comment.id
            }
          }.to change { comment.likes.size }.by -1

          assigns(:item_type).should == Comment
          assigns(:item).should == comment
          assigns(:upvote_count).should == '0'
          assigns(:downvote_count).should == '0'
          assigns(:total_vote_count).should == '0'

          response.code.should eq '200'
        end
      end

      context 'post not already voted on' do
        it 'adds a vote' do
          expect {
            xhr :post, :upvote, {
              item_type: :post,
              item_id: post_one.id
            }
          }.to change { post_one.likes.size }.by 1

          assigns(:item_type).should == Post
          assigns(:item).should == post_one
          assigns(:upvote_count).should == '1'
          assigns(:downvote_count).should == '0'
          assigns(:total_vote_count).should == '1'

          response.code.should eq '200'
        end
      end

      context 'post already voted on' do
        before do
          post_one.liked_by users(:bob)
        end

        it 'removes a vote' do
          expect {
            xhr :post, :upvote, {
              item_type: :post,
              item_id: post_one.id
            }
          }.to change { post_one.likes.size }.by -1

          assigns(:item_type).should == Post
          assigns(:item).should == post_one
          assigns(:upvote_count).should == '0'
          assigns(:downvote_count).should == '0'
          assigns(:total_vote_count).should == '0'

          response.code.should eq '200'
        end
      end
    end
  end

  describe '#downvote' do
    context 'user not logged in' do
      it 'returns a 401' do
        expect {
          xhr :post, :downvote, {
            item_type: :comment,
            item_id: comment.id
          }
        }.to_not change { comment.votes.size }

        response.code.should eq '401'
      end
    end

    context 'user logged in' do
      before do
        sign_in users(:bob)
      end

      context 'comment not already voted on' do
        it 'adds a vote' do
          expect {
            xhr :post, :downvote, {
              item_type: :comment,
              item_id: comment.id
            }
          }.to change { comment.dislikes.size }.by 1

          assigns(:item_type).should == Comment
          assigns(:item).should == comment
          assigns(:upvote_count).should == '0'
          assigns(:downvote_count).should == '1'
          assigns(:total_vote_count).should == '-1'

          response.code.should eq '200'
        end
      end

      context 'comment already voted on' do
        before do
          comment.disliked_by users(:bob)
        end

        it 'removes a vote' do
          expect {
            xhr :post, :downvote, {
              item_type: :comment,
              item_id: comment.id
            }
          }.to change { comment.dislikes.size }.by -1

          assigns(:item_type).should == Comment
          assigns(:item).should == comment
          assigns(:upvote_count).should == '0'
          assigns(:downvote_count).should == '0'
          assigns(:total_vote_count).should == '0'

          response.code.should eq '200'
        end
      end

      context 'post not already voted on' do
        it 'adds a vote' do
          expect {
            xhr :post, :downvote, {
              item_type: :post,
              item_id: post_one.id
            }
          }.to change { post_one.dislikes.size }.by 1

          assigns(:item_type).should == Post
          assigns(:item).should == post_one
          assigns(:upvote_count).should == '0'
          assigns(:downvote_count).should == '1'
          assigns(:total_vote_count).should == '-1'

          response.code.should eq '200'
        end
      end

      context 'post already voted on' do
        before do
          post_one.disliked_by users(:bob)
        end

        it 'removes a vote' do
          expect {
            xhr :post, :downvote, {
              item_type: :post,
              item_id: post_one.id
            }
          }.to change { post_one.dislikes.size }.by -1

          assigns(:item_type).should == Post
          assigns(:item).should == post_one
          assigns(:upvote_count).should == '0'
          assigns(:downvote_count).should == '0'
          assigns(:total_vote_count).should == '0'

          response.code.should eq '200'
        end
      end
    end
  end

  describe '#item_class' do
    context 'invalid votable type' do
      it 'returns nil' do
        subject.send(:item_class, 'bobo').should be_nil
      end
    end

    context 'post' do
      it 'returns the Post class' do
        subject.send(:item_class, 'post').should eq Post
      end
    end

    context 'comment' do
      it 'returns the Comment class' do
        subject.send(:item_class, 'comment').should eq Comment
      end
    end
  end
end
