require 'spec_helper'


describe Api::SessionsController do
  let(:valid_attributes) do
    {
      email: 'test_user@test.com',
      password: 'passw0rd'
    }
  end

  let(:user) { FactoryGirl.create :user, valid_attributes }

  describe 'POST create' do
    describe 'with valid params' do
      before do
        user
        post :create, session: valid_attributes
      end

      it 'assigns the found user as @current_user' do
        expect(assigns(:current_user)).to eq user
      end

      it 'returns 201 with an empty body' do
        expect(response.status).to eq 201
        expect(response.body).to have_json_path 'access_token'
      end
    end

    describe 'with invalid params' do
      before do
        allow(subject).to receive(:login) { false }
        post :create, session: { email: 'blah@blh.com' }
      end

      it 'assigns nil to @user' do
        expect(assigns(:user)).to eq nil
      end

      it 'returns a 401 with JSON body' do
        expect(response.status).to eq 401
        expect(response.body).to be_json_eql JSON(errors: { 'session' => 'Unauthorized.' })
      end
    end
  end

  describe 'DELETE destroy' do
    context 'user exists with the access token' do
      before { login }

      it 'destroys the requested session' do
        expect(subject).to receive(:logout)
        delete :destroy, format: :json
      end
    end

    context 'user does not exist with the access token' do
      it 'returns a 401' do
        delete :destroy, format: :json

        expect(response.status).to eq 401
        expect(response.body).to be_json_eql '{"errors":{"session":"Not logged in."}}'
      end
    end
  end
end
