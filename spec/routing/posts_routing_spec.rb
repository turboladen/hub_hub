require 'spec_helper'

describe PostsController do
  describe 'routing' do

    it 'routes to #new' do
      get('/spokes/1/posts/new').should route_to 'posts#new', spoke_id: '1'
    end

    it 'routes to #show' do
      get('/spokes/1/posts/2').should route_to 'posts#show', spoke_id: '1', id: '2'
    end

    it 'routes to #edit' do
      get('/spokes/1/posts/2/edit').should route_to 'posts#edit', spoke_id: '1', id:  '2'
    end

    it 'routes to #create' do
      post('/spokes/1/posts').should route_to 'posts#create', spoke_id: '1'
    end

    it 'routes to #update' do
      put('/spokes/1/posts/2').should route_to 'posts#update', spoke_id: '1', id: '2'
    end

    it 'routes to #destroy' do
      delete('/spokes/1/posts/2').should route_to 'posts#destroy', spoke_id: '1', id: '2'
    end
  end
end
