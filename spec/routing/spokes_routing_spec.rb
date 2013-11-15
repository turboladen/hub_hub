require 'spec_helper'

describe SpokesController do
  describe 'routing' do
    it 'routes to #index' do
      get('/spokes').should route_to('spokes#index')
    end

    it 'routes to #new' do
      get('/spokes/new').should route_to('spokes#new')
    end

    it 'routes to #show' do
      get('/spokes/1').should route_to('spokes#show', :id => '1')
    end

    it 'routes to #edit' do
      get('/spokes/1/edit').should route_to('spokes#edit', :id => '1')
    end

    it 'routes to #create' do
      post('/spokes').should route_to('spokes#create')
    end

    it 'routes to #update' do
      put('/spokes/1').should route_to('spokes#update', :id => '1')
    end

    it 'routes to #destroy' do
      delete('/spokes/1').should route_to('spokes#destroy', :id => '1')
    end
  end
end
