require 'spec_helper'


describe CommentsController do
  fixtures :spokes
  fixtures :posts
  fixtures :comments
  fixtures :users

  let(:post_one) { posts(:post_one) }
  let(:comment) { comments(:comment_one) }
  let(:bob) { users(:bob) }

  describe '#create' do
    context 'user not logged in' do
      it 'redirects the user to sign in' do
        post :create, spoke_id: post_one.spoke_id, post_id: post_one,
          comment: { body: 'stuff' }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'user logged in' do
      before { sign_in bob }

      context 'no comment info given' do
        it 'redirects back to the spoke and flashes the errors' do
          expect {
            post :create, spoke_id: post_one.spoke_id, post_id: post_one
          }.to_not change { Comment.count }.by 1

          flash[:error].should == "Body can't be blank"
          expect(response).
            to redirect_to spoke_post_path(post_one.spoke_id, post_one)
        end
      end

      context 'comment body provided' do
        it 'creates a new comment' do
          expect {
            post :create, spoke_id: post_one.spoke_id, post_id: post_one,
              comment: { body: 'stuff' }
          }.to change { Comment.count }.by 1

          comment = Comment.last
          assigns(:comment).should == comment

          flash[:notice].should == 'Your response was added.'
          expect(response).
            to redirect_to(spoke_post_path(post_one.spoke_id, post_one))

          comment.body.should == 'stuff'
          comment.post_id.should == post_one.id
        end
      end

      context 'comment on a comment' do
        let!(:parent_comment) do
          c = Comment.build_from(post_one, bob.id, 'sup')
          c.save!

          c
        end

        it 'creates a new comment on the comment' do
          expect {
            post :create, {
              post_id: post_one.id,
              spoke_id: post_one.spoke_id,
              comment: { body: 'stuff' },
              parent_type: :comment,
              parent_id: parent_comment.id
            }
          }.to change { Comment.count }.by 1

          assigns(:post).should == post_one
          assigns(:current_user).should == bob
          assigns(:comment).should == Comment.last
        end
      end

      context 'comment fails to save' do
        before { sign_in bob }

        let(:comment) do
          c = double 'Comment'
          c.stub(:save).and_return false
          c.stub_chain(:errors, :full_messages, :join).and_return 'Some errors!'

          c
        end

        it 'redirects back to the post' do
          Comment.should_receive(:build_from).and_return comment

          post :create, { post_id: post_one.id, spoke_id: post_one.spoke_id,
            comment: { body: 'stuff' } }

          expect(response).to redirect_to spoke_post_path(post_one.spoke, post_one)
          flash[:error].should == 'Some errors!'
        end
      end

      context 'comment fails to be made a child of another comment' do
        before { sign_in bob }

        let(:comment) do
          c = double 'Comment'
          c.stub(:save).and_return(true, false)
          c.stub(:move_to_child_of)
          c.should_receive(:make_child_of).with('123').and_return false

          c
        end

        let(:parent_comment) do
          double 'Comment', id: 123
        end

        it 'redirects back to the post' do
          Comment.should_receive(:build_from).and_return comment

          post :create, { post_id: post_one.id, spoke_id: post_one.spoke_id,
            parent_type: 'comment', parent_id: 123, comment: { body: 'stuff' } }

          expect(response).to redirect_to spoke_post_path(post_one.spoke, post_one)
          flash[:error].should == 'Unable to make response a child response.'
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
        expect(response).to redirect_to spoke_post_path(post_one.spoke, post_one)
      end
    end

    context 'user signed in and owner of post' do
      before do
        sign_in bob
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
        sign_in bob
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
      it 'returns a 401' do
        expect {
          delete :destroy, spoke_id: comment.post.spoke_id, post_id: comment.post_id,
            id: comment.id, format: :js
        }.to_not change { Comment.count }

        response.code.should eq '401'
      end
    end

    context 'user signed in, owns comment, but not an admin' do
      before { sign_in bob }

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

  describe '#flag' do
    context 'user not signed in' do
      it 'redirects the user to sign in' do
        put :flag, spoke_id: comment.post.spoke_id, post_id: comment.post.id, comment_id: comment.id,
          flag_type: :inappropriate, format: :js
        response.code.should == '401'
      end
    end

    context 'user signed in but not owner of post' do
      before do
        sign_in users(:ricky)
      end

      it 'flags the item' do
        put :flag, spoke_id: comment.post.spoke_id, post_id: comment.post.id, comment_id: comment.id,
          flag_type: :inappropriate, format: :js
        assigns(:comment).should == comment
        response.should render_template 'comments/flag'
        response.code.should eq '200'
      end
    end

    context 'user signed in and owner of post' do
      before do
        sign_in bob
      end

      it 'flags the item' do
        put :flag, spoke_id: comment.post.spoke_id, post_id: comment.post.id, comment_id: comment.id,
          flag_type: :inappropriate, format: :js
        assigns(:comment).should == comment
        response.should render_template 'comments/flag'
        response.code.should eq '200'
      end
    end
  end
end
