require 'spec_helper'


describe PostsController do
  fixtures :spokes
  fixtures :posts
  fixtures :users

  describe '#create' do
    context 'user not logged in' do
      it 'returns a RoutingError' do
        post :create, spoke_id: spokes(:fresno),
          post: { title: 'test', content: 'stuff' }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'user logged in' do
      before { sign_in users(:bob) }

      context 'bad spoke ID given' do
        it 'creates a new post' do
          expect {
            post :create, spoke_id: 1231231231231231231,
              post: { title: 'test', content: 'stuff' }
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context 'no post info given' do
        it 'redirects back to the spoke and flashes the errors' do
          expect {
            post :create, spoke_id: spokes(:fresno)
          }.to_not change { Post.count }.by 1

          flash[:error].should ==
            "Title can't be blank; Title is too short (minimum is 2 characters); Content can't be blank"
          expect(response).to redirect_to spokes(:fresno)
        end
      end

      context 'post info given' do
        it 'creates a new post' do
          expect {
            post :create, spoke_id: spokes(:fresno),
              post: { title: 'test', content: 'stuff' }
          }.to change { Post.count }.by 1

          post = Post.last
          assigns(:post).should == post

          flash[:notice].should == 'Your post was created.'
          expect(response).to redirect_to(spoke_post_path(spokes(:fresno), post))

          post.title.should == 'test'
          post.content.should == 'stuff'
          post.spoke_id.should == spokes(:fresno).id
        end
      end
    end
  end

  describe '#show' do
    context 'invalid post id' do
      it 'raises' do
        get :show, spoke_id: spokes(:fresno).id, id: 123123123123
        flash[:error].should == "Couldn't find a Post with ID #{123123123123}"
        expect(response).to redirect_to spoke_url(spokes(:fresno))
      end
    end

    context 'valid post id, invalid spoke_id' do
      it 'displays the post' do
        get :show, id: posts(:post_one).id, spoke_id: 1231231231231

        assigns(:post).should == posts(:post_one)
        expect(response.code).to eq '200'
        response.should render_template 'show'
      end
    end

    context 'valid post id, valid spoke_id' do
      it 'displays the post' do
        get :show, id: posts(:post_one).id, spoke_id: posts(:post_one).spoke_id

        assigns(:post).should == posts(:post_one)
        expect(response.code).to eq '200'
        response.should render_template 'show'
      end
    end
  end

  describe '#edit' do
    context 'user not signed in' do
      it 'redirects the user to sign in' do
        get :edit, spoke_id: posts(:post_one).spoke_id, id: posts(:post_one).id
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'user signed in but not owner of post' do
      before do
        sign_in users(:ricky)
      end

      it 'redirects back to the post and flashes an error' do
        get :edit, spoke_id: posts(:post_one).spoke_id, id: posts(:post_one).id
        expect(response).to redirect_to spoke_post_url(posts(:post_one).spoke, posts(:post_one))
      end
    end

    context 'user signed in and owner of post' do
      before do
        sign_in users(:bob)
      end

      it 'renders the edit page' do
        get :edit, spoke_id: posts(:post_one).spoke_id, id: posts(:post_one).id
        assigns(:post).should == posts(:post_one)
        response.should render_template 'edit'
      end
    end
  end

  describe '#update' do
    context 'user not signed in' do
      it 'redirects the user to sign in' do
        put :update, spoke_id: posts(:post_one).spoke_id, id: posts(:post_one).id,
          post: { title: 'update stuff', content: 'i updated this!' }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'user signed in but not owner of post' do
      before do
        sign_in users(:ricky)
      end

      it 'redirects back to the post and flashes an error' do
        put :update, spoke_id: posts(:post_one).spoke_id, id: posts(:post_one).id,
          post: { title: 'update stuff', content: 'i updated this!' }
        expect(response).to redirect_to spoke_post_url(posts(:post_one).spoke, posts(:post_one))
      end
    end

    context 'user signed in and owner of post' do
      before do
        sign_in users(:bob)
      end

      it 'renders the edit page' do
        put :update, spoke_id: posts(:post_one).spoke_id, id: posts(:post_one).id,
          post: { title: 'update stuff', content: 'i updated this!' }

        assigns(:post).should == posts(:post_one)
        flash[:notice].should == 'Post was successfully updated.'
        expect(response).
          to redirect_to spoke_post_path(posts(:post_one).spoke, posts(:post_one))
      end
    end
  end

  describe '#flag' do
    context 'user not signed in' do
      it 'redirects the user to sign in' do
        put :flag, spoke_id: posts(:post_one).spoke_id, post_id: posts(:post_one).id,
          flag_type: :inappropriate, format: :js
        response.code.should == '401'
      end
    end

    context 'user signed in but not owner of post' do
      before do
        sign_in users(:ricky)
      end

      it 'flags the item' do
        put :flag, spoke_id: posts(:post_one).spoke_id, post_id: posts(:post_one).id,
          flag_type: :inappropriate, format: :js
        assigns(:post).should == posts(:post_one)
        response.should render_template 'posts/flag'
      end
    end

    context 'user signed in and owner of post' do
      before do
        sign_in users(:bob)
      end

      it 'flags the item' do
        put :flag, spoke_id: posts(:post_one).spoke_id, post_id: posts(:post_one).id,
          flag_type: :inappropriate, format: :js
        assigns(:post).should == posts(:post_one)
        response.should render_template 'posts/flag'
      end
    end
  end
end
