require 'spec_helper'

describe Api::UsersController do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/api/users/1').to route_to 'api/users#show', id: '1', format: 'json'
    end
  end
end
