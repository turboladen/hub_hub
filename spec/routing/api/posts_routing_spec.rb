require 'spec_helper'

describe Api::PostsController do
  describe 'routing' do

    it 'routes to #show' do
      expect(get: '/api/posts/2').to route_to 'api/posts#show', id: '2',
        format: 'json'
    end

    it 'routes to #create' do
      expect(post: '/api/posts').to route_to 'api/posts#create', format: 'json'
    end

    it 'routes to #update' do
      expect(patch: '/api/posts/2').to route_to 'api/posts#update', id: '2',
        format: 'json'
    end

    it 'routes to #destroy' do
      expect(delete: '/api/posts/2').to route_to 'api/posts#destroy', id: '2',
        format: 'json'
    end
  end
end
