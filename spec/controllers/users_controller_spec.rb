require 'spec_helper'

describe UsersController do
  let(:valid_attributes) { FactoryGirl.attributes_for :user }
  let(:user) { FactoryGirl.create :user }

  describe 'GET show' do
    it 'assigns the requested user as @user' do
      get :show, id: user.to_param, format: :json
      assigns(:user).should eq(user)
    end
  end
end
