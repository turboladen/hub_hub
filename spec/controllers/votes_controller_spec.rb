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

          assigns(:item_type).should == 'comment'
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

          assigns(:item_type).should == 'comment'
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

          assigns(:item_type).should == 'post'
          assigns(:item).should == post_one
          assigns(:upvote_count).should == '1'
          assigns(:downvote_count).should == '0'
          assigns(:total_vote_count).should == '1'

          response.code.should eq '200'
        end
      end

      context 'comment already voted on' do
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

          assigns(:item_type).should == 'post'
          assigns(:item).should == post_one
          assigns(:upvote_count).should == '0'
          assigns(:downvote_count).should == '0'
          assigns(:total_vote_count).should == '0'

          response.code.should eq '200'
        end
      end
    end
  end
end
