require 'spec_helper'


describe HomeController do
  fixtures :spokes
  fixtures :posts

  describe '#index' do

    it 'displays the spoke' do
      get :index

      assigns(:posts).size.should == Post.count

      expect(response.code).to eq '200'
      response.should render_template 'index'
    end

    context 'params[:sort] given but not valid' do
      it 'uses :newest' do
        get :index, sort: 'sdkfljsdk'

        assigns(:sorter).should == :newest
        expect(response.code).to eq '200'
      end
    end

    context 'params[:sort] given and is valid' do
      it 'uses the param value' do
        get :index, sort: :most_active

        assigns(:sorter).should == :most_active
        expect(response.code).to eq '200'
      end
    end

    context 'params[:sort] not given' do
      it 'uses :newest' do
        get :index

        assigns(:sorter).should == :newest
        expect(response.code).to eq '200'
      end
    end
  end

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
