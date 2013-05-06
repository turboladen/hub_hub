require 'spec_helper'


describe HomeController do
  fixtures :spokes
  fixtures :posts

  describe '#tos' do
    it 'renders the terms of service' do
      get :tos

      response.should render_template 'tos'
    end
  end

  describe '#faq' do
    it 'renders the FAQ' do
      get :faq

      response.should render_template 'faq'
    end
  end
end
