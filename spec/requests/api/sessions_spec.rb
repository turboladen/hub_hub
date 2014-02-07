require 'spec_helper'

describe 'Sessions' do
  let(:user) { FactoryGirl.create :user }

  describe 'POST /api/sessions' do
    context 'valid user' do
      it 'logs a user in' do
        post '/api/sessions', session: { email: user.email, password: 'password' }

        expect(response.status).to eq 201
        expect(response.body).to be_json_eql JSON(
          {
            user_id: user.id,
            access_token: user.auth_token,
            expires_in: 7200
          }
        )
      end
    end

    context 'bad password' do
      it 'returns a 401 with JSON error' do
        post '/api/sessions', session: { email: user.email, password: 'word' }

        expect(response.status).to eq 401
        expect(response.body).to be_json_eql JSON(errors: { session: 'Unauthorized.' })
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
    before { login user }

    it 'logs the user out' do
      delete '/api/sessions', {}, with_headers(auth: true)
      expect(response.status).to eq 204
      expect(response.body).to be_empty
    end
  end
end
