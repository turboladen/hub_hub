require 'spec_helper'


describe CommentsController do
  fixtures :spokes
  fixtures :posts
  fixtures :users

  describe '#create' do
    context 'user not logged in' do
      it 'redirects the user to sign in' do
        post :create, spoke_id: posts(:post_one).spoke_id, post_id: posts(:post_one),
          comment: { body: 'stuff' }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'user logged in' do
      before { sign_in users(:bob) }

      context 'no comment info given' do
        it 'redirects back to the spoke and flashes the errors' do
          expect {
            post :create, spoke_id: posts(:post_one).spoke_id, post_id: posts(:post_one)
          }.to_not change { Comment.count }.by 1

          flash[:error].should == "Body can't be blank"
          expect(response).
            to redirect_to spoke_post_path(posts(:post_one).spoke_id, posts(:post_one))
        end
      end

      context 'comment body provided' do
        it 'creates a new post' do
          expect {
            post :create, spoke_id: posts(:post_one).spoke_id, post_id: posts(:post_one),
              comment: { body: 'stuff' }
          }.to change { Comment.count }.by 1

          comment = Comment.last
          assigns(:comment).should == comment

          flash[:notice].should == 'Your response was added.'
          expect(response).
            to redirect_to(spoke_post_path(posts(:post_one).spoke_id, posts(:post_one)))

          comment.body.should == 'stuff'
          comment.post_id.should == posts(:post_one).id
        end
      end
    end
  end
end
