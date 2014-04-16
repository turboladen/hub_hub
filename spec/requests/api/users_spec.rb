require 'spec_helper'

describe 'Users' do
  describe 'POST /api/users' do
    context 'acceptable params' do
      it 'creates a new user' do
        post '/api/users.json', user: {
          username: 'test',
          email: 'test@example.com',
          first_name: 'FirstName',
          last_name: 'LastName',
          password: 'passw0rd',
          password_confirmation: 'passw0rd'
        }

        user = User.last
        expect(response.status).to eq 201
        expect(response.body).to be_json_eql JSON(
          user: {
            id: user.id,
            email: 'test@example.com',
            first_name: 'FirstName',
            last_name: 'LastName',
            admin: false,
            banned: false,
            post_ids: []
          }
        )
      end
    end

    context 'missing required params' do
      it 'returns a ' do
        post '/api/users.json', user: {
          first_name: 'FirstName',
          last_name: 'LastName',
          password: 'passw0rd',
          password_confirmation: 'passw0rd'
        }

        expect(response.status).to eq 422
        expect(response.body).to be_json_eql JSON(
          errors: { email: ["can't be blank", 'is invalid'] }
        )
      end
    end
  end

  describe 'GET /api/users/:id' do
    context 'user with :id exists' do
      let!(:user) { FactoryGirl.create :user }

      it 'retrieves the user' do
        get "/api/users/#{user.to_param}.json"

        expect(response.status).to eq 200
        expect(response.body).to be_json_eql JSON(
          user: {
            id: user.id,
            email: user.email,
            first_name: user.first_name,
            last_name: user.last_name,
            admin: user.admin?,
            banned: user.banned?,
            post_ids: []
          }
        )
      end
    end

    context 'user with :id does not exist' do
      it 'gets a 404 as JSON' do
        get '/api/users/123456789.json'

        expect(response.status).to eq 404
        expect(response.body).to be_json_eql JSON(
          errors: {
            'id' => "Couldn't find User with id=123456789"
          }
        )
      end
    end
  end

  describe 'PATCH /api/users/:id' do
    let!(:user) { FactoryGirl.create :user }
    before { login user }

    context 'user with :id exists' do
      it 'updates the user' do
        patch "/api/users/#{user.to_param}.json", {
          user: { first_name: '123456789' }
        }

        expect(response.status).to eq 204
        expect(response.body).to be_empty
        user = User.last
        expect(user.first_name).to eq '123456789'
      end
    end

    context 'user with :id does not exist' do
      it 'gets a 404 as JSON' do
        patch '/api/users/123456789.json', {
          user: { username: '123456789' }
        }

        expect(response.status).to eq 404
        expect(response.body).to be_json_eql JSON(
          errors: {
            'id' => "Couldn't find User with id=123456789"
          }
        )
      end
    end
  end

  describe 'DELETE /api/users/:id' do
    context 'user with :id exists' do
      let!(:user) { FactoryGirl.create :user }

      it 'deletes the user' do
        delete "/api/users/#{user.to_param}.json"

        expect(response.status).to eq 204
        expect(response.body).to be_empty
        expect {
          User.find(user)
        }.to raise_exception ActiveRecord::RecordNotFound,
          "Couldn't find User with 'id'=#{user.id}"
      end
    end

    context 'user with :id does not exist' do
      it 'gets a 404 as JSON' do
        delete '/api/users/123456789.json'

        expect(response.status).to eq 404
        expect(response.body).to be_json_eql JSON(
          errors: {
            'id' => "Couldn't find User with id=123456789"
          }
        )
      end
    end
  end
end
