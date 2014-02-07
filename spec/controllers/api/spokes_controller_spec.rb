require 'spec_helper'

describe Api::SpokesController do
  let(:valid_attributes) { FactoryGirl.attributes_for :spoke }

  describe 'GET index' do
    it 'assigns all spokes as @spokes' do
      spoke = Spoke.create! valid_attributes
      get :index, format: :json
      assigns(:spokes).should eq([spoke])
    end
  end

  describe 'GET show' do
    it 'assigns the requested spoke as @spoke' do
      spoke = Spoke.create! valid_attributes
      get :show, id: spoke.to_param, format: :json
      assigns(:spoke).should eq(spoke)
    end
  end
end
