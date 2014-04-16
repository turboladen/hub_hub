require 'spec_helper'

describe Api::PostsController do
  let(:new_post) { FactoryGirl.create :post }

  describe 'GET index' do
    let!(:posts) { FactoryGirl.create_list :post, 2 }

    context 'with ids' do
      it 'assigns posts with the given ids as @posts' do
        get :index, ids: posts.map(&:id), format: :json
        assigns(:posts).should eq(posts)
      end
    end

    context 'without ids' do
      it 'assigns all posts as @posts' do
        get :index, format: :json
        assigns(:posts).should eq(posts)
      end
    end
  end

  describe 'GET show' do
    it 'assigns the requested post as @post' do
      get :show, id: new_post.to_param, format: :json
      assigns(:post).should eq(new_post)
    end
  end

  describe 'POST create' do
    let(:valid_attributes) { FactoryGirl.attributes_for :post, spoke_id: spoke.id }
    let!(:spoke) { FactoryGirl.create :spoke }
    let(:user) { FactoryGirl.create :user }

    before do
      login user
    end

    describe 'with valid params' do
      it 'creates a new Post' do
        expect {
          post :create, post: valid_attributes, format: :json
        }.to change(Post, :count).by(1)
      end

      it 'assigns a newly created post as @post' do
        post :create, post: valid_attributes, format: :json
        assigns(:post).should be_a(Post)
        assigns(:post).should be_persisted
      end

      it 'returns a 201 with Location header and the payload as JSON' do
        post :create, post: valid_attributes, format: :json

        expect(response.status).to eq 201
        expect(response.headers).to include 'Location'
        expect(response.body).to be_json_eql(Post.last.id).at_path('post/id')
        expect(response.body).to be_json_eql(spoke.id).at_path('post/spoke_id')
        expect(response.body).to be_json_eql(user.id).at_path('post/owner_id')
      end
    end

    describe 'with invalid params' do
      before do
        post :create,
          post: { 'not acceptable' => 'invalid value' },
          format: :json
      end

      it 'assigns a newly created but unsaved post as @post' do
        assigns(:post).should be_a_new(Post)
      end

      it 'returns a 422 with errors as JSON' do
        expect(response.status).to eq 422
        expect(response.body).to have_json_type(Hash).at_path('errors')
      end
    end
  end

  describe 'PUT update' do
    before { login }
    let(:valid_attributes) { FactoryGirl.attributes_for :post, spoke_id: spoke.id }
    let!(:spoke) { FactoryGirl.create :spoke }

    describe 'with valid params' do
      it 'updates the requested post' do
        # Assuming there are no other posts in the database, this
        # specifies that the Post created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Post.any_instance.should_receive(:update).with({ 'title' => 'MyString' })
        put :update,
          id: new_post.to_param,
          post: { 'title' => 'MyString' },
          format: :json
      end

      it 'assigns the requested post as @post' do
        put :update,
          id: new_post.to_param,
          post: valid_attributes,
          format: :json
        assigns(:post).should eq(new_post)
      end

      it 'returns a 204' do
        put :update,
          id: new_post.to_param,
          post: valid_attributes,
          format: :json
        expect(response.status).to eq 204
        expect(response.body).to be_empty
      end
    end

    describe 'with invalid params' do
      before do
        put :update,
          id: new_post.to_param,
          post: bad_attributes,
          format: :json
      end

      let(:bad_attributes) do
        valid_attributes[:title] = ''

        valid_attributes
      end

      it 'assigns the post as @post' do
        assigns(:post).should eq(new_post)
      end

      it 'returns a 422 with errors as JSON' do
        expect(response.status).to eq 422
        expect(response.body).to have_json_type(Hash).at_path('errors')
      end
    end
  end

  describe 'DELETE destroy' do
    before { new_post }

    it 'destroys the requested post' do
      expect {
        delete :destroy, id: new_post.to_param, format: :json
      }.to change(Post, :count).by(-1)
    end

    it 'returns an empty body with 204' do
      delete :destroy, id: new_post.to_param, format: :json
      expect(response.status).to eq 204
      expect(response.body).to be_empty
    end
  end
end
