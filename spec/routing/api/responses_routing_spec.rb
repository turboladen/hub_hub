require 'spec_helper'

describe Api::ResponsesController do
  describe 'routing' do
    it 'routes to #index' do
      get('/api/responses').should route_to('api/responses#index', format: 'json')
    end

    it 'routes to #show' do
      get('/api/responses/1').should route_to('api/responses#show', id: '1', format: 'json')
    end

    it 'routes to #create' do
      post('/api/responses').should route_to('api/responses#create', format: 'json')
    end

    it 'routes to #update' do
      put('/api/responses/1').should route_to('api/responses#update', id: '1', format: 'json')
    end

    it 'routes to #destroy' do
      delete('/api/responses/1').should route_to('api/responses#destroy', id: '1', format: 'json')
    end
  end
end
