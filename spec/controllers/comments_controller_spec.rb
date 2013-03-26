require 'spec_helper'


describe CommentsController do
  fixtures :spokes
  fixtures :posts
  fixtures :comments
  fixtures :users

  let(:post) { posts(:post_one) }
  let(:comment) { comments(:comment_one) }

  describe '#create' do
    context 'user not logged in' do
      it 'redirects the user to sign in' do
        post :create, spoke_id: post.spoke_id, post_id: post,
          comment: { body: 'stuff' }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'user logged in' do
      before { sign_in users(:bob) }

      context 'no comment info given' do
        it 'redirects back to the spoke and flashes the errors' do
          expect {
            post :create, spoke_id: post.spoke_id, post_id: post
          }.to_not change { Comment.count }.by 1

          flash[:error].should == "Body can't be blank"
          expect(response).
            to redirect_to spoke_post_path(post.spoke_id, post)
        end
      end

      context 'comment body provided' do
        it 'creates a new post' do
          expect {
            post :create, spoke_id: post.spoke_id, post_id: post,
              comment: { body: 'stuff' }
          }.to change { Comment.count }.by 1

          comment = Comment.last
          assigns(:comment).should == comment

          flash[:notice].should == 'Your response was added.'
          expect(response).
            to redirect_to(spoke_post_path(post.spoke_id, post))

          comment.body.should == 'stuff'
          comment.post_id.should == post.id
        end
      end
    end
  end

  describe '#edit' do
    context 'user not signed in' do
      it 'redirects the user to sign in' do
        get :edit, spoke_id: comment.post.spoke_id, post_id: comment.post_id,
          id: comment.id, comment: { body: 'STUFF!' }
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
        expect(response).to redirect_to spoke_post_path(post.spoke, post)
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

  describe '#update' do
    context 'user not signed in' do
      it 'redirects the user to sign in' do
        put :update, spoke_id: comment.post.spoke_id, post_id: comment.post_id,
          id: comment.id, comment: { body: 'STUFF!' }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'user signed in but not owner of post' do
      before do
        sign_in users(:ricky)
      end

      it 'redirects back to the post and flashes an error' do
        put :update, spoke_id: comment.post.spoke_id, post_id: comment.post_id,
          id: comment.id, comment: { body: 'STUFF!' }
        flash[:error].should ==
          'You must have created the response to be able to update it.'
        expect(response).to redirect_to spoke_post_url(comment.post.spoke, comment.post)
      end
    end

    context 'user signed in and owner of post' do
      before do
        sign_in users(:bob)
      end

      it 'renders the edit page' do
        put :update, spoke_id: comment.post.spoke_id, post_id: comment.post_id,
          id: comment.id, comment: { body: 'STUFF!' }

        assigns(:comment).should == comment
        flash[:notice].should == 'Response was successfully updated.'
        expect(response).
          to redirect_to spoke_post_path(comment.post.spoke, comment.post)
      end
    end
  end

  describe '#destroy' do
    context 'user not signed in' do
      it 'redirects the user to sign in' do
        expect {
          delete :destroy, spoke_id: comment.post.spoke_id, post_id: comment.post_id,
            id: comment.id, format: :js
        }.to_not change { Comment.count }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'user signed in, owns comment, but not an admin' do
      before { sign_in users(:bob) }

      it 'raises' do
        expect {
          delete :destroy, spoke_id: comment.post.spoke_id, post_id: comment.post_id,
            id: comment.id, format: :js
        }.to raise_error ActionController::RoutingError
      end
    end

    context 'admin signed in' do
      before { sign_in users(:admin) }

      it 'disables the comment when :disable is true' do
        expect {
          delete :destroy, spoke_id: comment.post.spoke_id, post_id: comment.post_id,
            id: comment.id, format: :js, disable: 'true'
        }.to change { Comment.deleted.count }.by 1

        flash[:notice].should == "Disabled response #{comment.id}"
        expect(response).to render_template 'comments/destroy'
      end

      it 'enables the comment when :disable is false' do
        comment.destroy

        expect {
          delete :destroy, spoke_id: comment.post.spoke_id, post_id: comment.post_id,
            id: comment.id, format: :js, disable: 'false'
        }.to change { Comment.not_deleted.count }.by 1

        flash[:notice].should == "Revived response #{comment.id}"
        expect(response).to render_template 'comments/destroy'
      end
    end
  end
end
