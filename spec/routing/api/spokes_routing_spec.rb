require 'spec_helper'

describe Api::SpokesController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/spokes').to route_to 'api/spokes#index', format: 'json'
    end

    it 'routes to #show' do
      expect(get: '/api/spokes/1').to route_to 'api/spokes#show', id: '1', format: 'json'
    end
  end
end
