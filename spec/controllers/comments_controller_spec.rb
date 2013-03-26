require 'spec_helper'


describe CommentsController do
  fixtures :spokes
  fixtures :posts
  fixtures :comments
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

  describe '#edit' do
    let(:comment) { comments(:comment_one) }

    context 'user not signed in' do
      it 'redirects the user to sign in' do
        get :edit, spoke_id: comment.post.spoke_id, post_id: comment.post_id,
          id: comment.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'user signed in but not owner of comment' do
      before do
        sign_in users(:ricky)
      end

      it 'redirects back to the post and flashes an error' do
        get :edit, spoke_id: comment.post.spoke_id, post_id: comment.post_id,
          id: comment.id, comment: { body: 'STUFF!' }
        flash[:error].should ==
          'You must have created the response to be able to edit it.'
        expect(response).to redirect_to spoke_post_path(posts(:post_one).spoke, posts(:post_one))
      end
    end

    context 'user signed in and owner of post' do
      before do
        sign_in users(:bob)
      end

      it 'renders the edit page' do
        get :edit, spoke_id: comment.post.spoke_id, post_id: comment.post_id,
          id: comment.id, comment: { body: 'STUFF!' }
        assigns(:comment).should == comment
        response.should render_template 'edit'
      end
    end
  end
end
