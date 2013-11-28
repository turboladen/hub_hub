require 'spec_helper'

describe Api::SessionsController do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/api/sessions').to route_to 'api/sessions#create', format: 'json'
    end

    it 'routes to #destroy' do
      expect(delete: '/api/sessions').to route_to 'api/sessions#destroy',
        format: 'json'
    end
  end
end
