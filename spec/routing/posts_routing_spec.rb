require 'spec_helper'

describe PostsController do
  describe 'routing' do

    it 'routes to #show' do
      get('/posts/2').should route_to 'posts#show', id: '2', format: 'json'
    end

    it 'routes to #create' do
      post('/posts').should route_to 'posts#create', format: 'json'
    end

    it 'routes to #update' do
      put('/posts/2').should route_to 'posts#update', id: '2', format: 'json'
    end

    it 'routes to #destroy' do
      delete('/posts/2').should route_to 'posts#destroy', id: '2', format: 'json'
    end
  end
end
