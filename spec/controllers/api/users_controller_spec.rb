require 'spec_helper'

describe Api::UsersController do
  let(:valid_attributes) { FactoryGirl.attributes_for :user }
  let(:new_user) { FactoryGirl.create :user }

  describe 'POST create' do
    context 'with valid params' do
      it 'creates a new User' do
        expect {
          post :create, user: valid_attributes, format: :json
        }.to change(User, :count).by(1)
      end

      it 'assigns a newly created post as @post' do
        post :create, user: valid_attributes, format: :json
        assigns(:user).should be_a(User)
        assigns(:user).should be_persisted
      end

      it 'returns a 201 with Location header and the payload as JSON' do
        post :create, user: valid_attributes, format: :json

        expect(response.status).to eq 201
        expect(response.headers).to include 'Location'
        expect(response.body).to have_json_path 'user'
      end
    end

    context 'with invalid params' do
      before do
        post :create,
          user: { 'not acceptable' => 'invalid value' },
          format: :json
      end

      it 'assigns a newly created but unsaved post as @user' do
        assigns(:user).should be_a_new User
      end

      it 'returns a 422 with errors as JSON' do
        expect(response.status).to eq 422
        expect(response.body).to have_json_type(Hash).at_path('errors')
      end
    end
  end

  describe 'GET show' do
    it 'assigns the requested user as @user' do
      get :show, id: new_user.to_param, format: :json
      assigns(:user).should eq(new_user)
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested post' do
        # Assuming there are no other users in the database, this
        # specifies that the User created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        User.any_instance.should_receive(:update).with({ 'email' => 'MyString@domain.com' })
        put :update,
          id: new_user.to_param,
          user: { 'email' => 'MyString@domain.com' },
          format: :json
      end

      it 'assigns the requested user as @user' do
        put :update,
          id: new_user.to_param,
          user: valid_attributes,
          format: :json
        assigns(:user).should eq(new_user)
      end

      it 'returns a 204' do
        put :update,
          id: new_user.to_param,
          user: valid_attributes,
          format: :json
        expect(response.status).to eq 204
        expect(response.body).to be_empty
      end
    end

    describe 'with invalid params' do
      before do
        put :update,
          id: new_user.to_param,
          user: bad_attributes,
          format: :json
      end

      let(:bad_attributes) do
        valid_attributes[:email] = ''

        valid_attributes
      end

      it 'assigns the user as @user' do
        assigns(:user).should eq(new_user)
      end

      it 'returns a 422 with errors as JSON' do
        expect(response.status).to eq 422
        expect(response.body).to have_json_type(Hash).at_path('errors')
      end
    end
  end

  describe 'DELETE destroy' do
    before { new_user }

    it 'destroys the requested user' do
      expect {
        delete :destroy, id: new_user.to_param, format: :json
      }.to change(User, :count).by(-1)
    end

    it 'returns an empty body with 204' do
      delete :destroy, id: new_user.to_param, format: :json
      expect(response.status).to eq 204
      expect(response.body).to be_empty
    end
  end
end
