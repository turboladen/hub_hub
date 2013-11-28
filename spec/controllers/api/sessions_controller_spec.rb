require 'spec_helper'


describe Api::SessionsController do
  let(:valid_attributes) do
    { username: 'test_user', password: 'passw0rd', remember_me: true }
  end

  let(:user) { double 'User' }

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Session' do
        expect(subject).to receive(:login).with('test_user', 'passw0rd', true)
        post :create, session: valid_attributes
      end

      it 'assigns the found user as @user' do
        expect(subject).to receive(:login) { user }
        post :create, session: valid_attributes
        expect(assigns(:user)).to eq user
      end

      it 'returns 201 with an empty body' do
        expect(subject).to receive(:login) { user }
        post :create, session: valid_attributes

        expect(response.status).to eq 201
        expect(response.body.strip).to be_empty
      end
    end

    describe 'with invalid params' do
      before do
        allow(subject).to receive(:login) { false }
        post :create, session: { username: 'blah' }
      end

      it 'assigns false to @user' do
        expect(assigns(:user)).to eq false
      end

      it 'returns a 401 with JSON body' do
        expect(response.status).to eq 401
        expect(response.body).to eq JSON(errors: { 'session' => 'Unauthorized.' })
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested session' do
      expect(subject).to receive(:logout)
      delete :destroy, format: :json
    end
  end
end
