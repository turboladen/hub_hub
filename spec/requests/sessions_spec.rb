require 'spec_helper'

describe 'Sessions' do
  let(:user) { FactoryGirl.create :user }

  describe 'POST /api/sessions' do
    context 'valid user' do
      it 'logs a user in' do
        post '/api/sessions', session: { username: user.username, password: 'password',
          remember_me: true }

        expect(response.status).to eq 201
        expect(response.body).to eq JSON(auth_token: user.reload.remember_me_token)
      end
    end

    context 'bad password' do
      it 'returns a 401 with JSON error' do
        post '/api/sessions', session: { username: user.username,
          password: 'word', remember_me: true }

        expect(response.status).to eq 401
        expect(response.body).to eq JSON(errors: { session: 'Unauthorized.' })
      end
    end

    context 'missing params' do
      it 'returns a 401 with JSON error' do
        post '/api/sessions', session: { password: 'password', remember_me: true }

        expect(response.status).to eq 401
        expect(response.body).to eq JSON(errors: { session: 'Unauthorized.' })
      end
    end
  end

  describe 'DELETE /api/sessions' do
    it 'logs the user out' do
      post '/api/sessions', session: { username: user.username, password: 'password',
        remember_me: true }

      delete '/api/sessions'
      expect(response.status).to eq 204
      expect(response.body).to be_empty
    end
  end
end
