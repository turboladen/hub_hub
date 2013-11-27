require 'spec_helper'

describe Api::PostsController do
  let(:valid_attributes) { FactoryGirl.attributes_for :post }
  let(:new_post) { FactoryGirl.create :post }

  describe 'GET index' do
    let(:relation) { double 'Post relation' }

    before do
      expect(Post).to receive(:includes).with(:spoke, :owner) { relation }
    end

    context 'with ids' do
      it 'assigns posts with the given ids as @posts' do
        expect(relation).to receive(:find).with(%w[1 2]) { relation }
        get :index, ids: %w[1 2], format: :json
        assigns(:posts).should eq(relation)
      end
    end

    context 'without ids' do
      it 'assigns all posts as @posts' do
        get :index, format: :json
        assigns(:posts).should eq(relation)
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
    let!(:spoke) { FactoryGirl.create :spoke }
    let(:user) { FactoryGirl.create :user }

    before do
      sign_in user
    end

    describe 'with valid params' do
      it 'creates a new Post' do
        expect {
          post :create, spoke_id: spoke.id, post: valid_attributes, format: :json
        }.to change(Post, :count).by(1)
      end

      it 'assigns a newly created post as @post' do
        post :create, spoke_id: spoke.id, post: valid_attributes, format: :json
        assigns(:post).should be_a(Post)
        assigns(:post).should be_persisted
      end

      it 'returns a 201 with Location header and the payload as JSON' do
        post :create, spoke_id: spoke.id, post: valid_attributes, format: :json

        expect(response.status).to eq 201
        expect(response.headers).to include 'Location'
        body = valid_attributes.merge 'id' => 1,
          'spoke_id' => spoke.id, 'owner_id' => user.id
        expect(response.body).to be_json_eql(JSON(post: body))
      end
    end

    describe 'with invalid params' do
      before do
        # Trigger the behavior that occurs when invalid params are submitted
        Post.any_instance.stub(:save).and_return(false)
        post :create,
          spoke_id: spoke.id,
          post: { 'not acceptable' => 'invalid value' },
          format: :json
      end

      it 'assigns a newly created but unsaved post as @post' do
        assigns(:post).should be_a_new(Post)
      end

      it 'returns a 422 with errors as JSON' do
        expect(response.status).to eq 422
        expect(response.body).to eq JSON(errors: {})
      end
    end
  end

  describe 'PUT update' do
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
        Post.any_instance.stub(:save).and_return(false)

        put :update,
          id: new_post.to_param,
          post: { 'title' => 'invalid value' },
          format: :json
      end

      it 'assigns the post as @post' do
        assigns(:post).should eq(new_post)
      end

      it 'returns a 422 with errors as JSON' do
        expect(response.status).to eq 422
        expect(response.body).to eq JSON(errors: {})
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
