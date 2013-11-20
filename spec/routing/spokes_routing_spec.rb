require 'spec_helper'

describe SpokesController do
  describe 'routing' do
    it 'routes to #index' do
      get('/spokes').should route_to('spokes#index')
    end

    it 'routes to #show' do
      get('/spokes/1').should route_to('spokes#show', :id => '1')
    end
  end
end
