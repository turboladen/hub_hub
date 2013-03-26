require 'spec_helper'


describe SpokesController do
  fixtures :spokes
  fixtures :posts

  describe '#show' do
    it 'displays the spoke' do
      get :show, id: spokes(:fresno)

      assigns(:spokes).should == Spoke.all
      assigns(:spoke).should == spokes(:fresno)
      assigns(:posts).size.should == 5
      expect(response.code).to eq '200'
      response.should render_template 'show'
    end

    context 'params[:sort] given but not valid' do
      it 'uses :newest' do
        get :show, id: spokes(:fresno), sort: 'sdkfljsdk'

        assigns(:sorter).should == :newest
      end
    end

    context 'params[:sort] given and is valid' do
      it 'uses the param value' do
        get :show, id: spokes(:fresno), sort: :most_active

        assigns(:sorter).should == :most_active
      end
    end

    context 'params[:sort] not given' do
      it 'uses :newest' do
        get :show, id: spokes(:fresno)

        assigns(:sorter).should == :newest
      end
    end
  end
end
