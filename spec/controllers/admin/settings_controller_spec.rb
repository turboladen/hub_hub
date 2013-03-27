require 'spec_helper'


describe Admin::SettingsController do
  fixtures :users

  describe '#index' do
    context 'user is not signed in' do
      it 'raises' do
        expect { get :index }.to raise_error ActionController::RoutingError
      end
    end

    context 'user not signed in but not admin' do
      before { sign_in users(:bob) }

      it 'raises' do
        expect { get :index }.to raise_error ActionController::RoutingError
      end
    end

    context 'admin is signed in' do
      before { sign_in users(:admin) }

      it 'displays the index' do
        get :index
        assigns(:settings).should == Settings.digest_email
        response.should render_template 'index'
      end
    end
  end

  describe '#create' do
    context 'user is not signed in' do
      it 'raises' do
        expect { post :create, send_time: '10:30' }.to raise_error ActionController::RoutingError
      end
    end

    context 'user not signed in but not admin' do
      before { sign_in users(:bob) }

      it 'raises' do
        expect { post :create, send_time: '10:30' }.to raise_error ActionController::RoutingError
      end
    end

    context 'admin is signed in' do
      before { sign_in users(:admin) }

      it 'displays the index' do
        pending 'Implementing settings'

        post :create, send_time: '10:30'
        assigns(:send_time).should == '10:30'
        Settings.digest_email[:send_time].should == '10:30'
        response.should render_template 'index'
      end
    end
  end
end
