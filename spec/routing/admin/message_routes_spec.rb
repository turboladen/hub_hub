require 'spec_helper'


describe 'admin/message routes', type: :routing do
  fixtures :users

  describe 'admin/message' do
    it 'responds to GET' do
      expect(get: '/admin/message').
        to route_to(
          action: 'new',
          controller: 'admin/message'
      )
    end
  end

  describe 'admin/message' do
    it 'responds to POST' do
      expect(post: '/admin/message').
        to route_to(
          action: 'create',
          controller: 'admin/message'
      )
    end
  end
end
