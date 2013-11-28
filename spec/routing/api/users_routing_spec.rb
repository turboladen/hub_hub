require 'spec_helper'

describe Api::UsersController do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/api/users').to route_to 'api/users#create', format: 'json'
    end

    it 'routes to #show' do
      expect(get: '/api/users/1').to route_to 'api/users#show', id: '1', format: 'json'
    end

    it 'routes to #update' do
      expect(patch: '/api/users/1').to route_to 'api/users#update', id: '1',
        format: 'json'
    end

    it 'routes to #destroy' do
      expect(delete: '/api/users/1').to route_to 'api/users#destroy', id: '1',
        format: 'json'
    end
  end
end
