require 'spec_helper'

describe 'Users' do
  describe 'GET /users/:id' do
    let!(:user) { FactoryGirl.create :user }

    it 'retrieves the user' do
      get "/users/#{user.to_param}.json"

      expect(response.status).to eq 200
      expect(response.body).to eq JSON(
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
end
