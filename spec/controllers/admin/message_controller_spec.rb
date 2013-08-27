require 'spec_helper'


describe Admin::MessageController do
  fixtures :users

  describe '#new' do
    context 'user is not signed in' do
      it 'raises' do
        expect { get :new }.to raise_error ActionController::RoutingError
      end
    end

    context 'user not signed in but not admin' do
      before { sign_in users(:bob) }

      it 'raises' do
        expect { get :new }.to raise_error ActionController::RoutingError
      end
    end

    context 'admin is signed in' do
      before { sign_in users(:admin) }

      it 'creates the new message' do
        get :new
        assigns(:message).should be_a Message
        response.should render_template 'new'
      end
    end
  end

  describe '#create' do
    context 'user is not signed in' do
      it 'raises' do
        expect { get :create }.to raise_error ActionController::RoutingError
      end
    end

    context 'user not signed in but not admin' do
      before { sign_in users(:bob) }

      it 'raises' do
        expect { get :create }.to raise_error ActionController::RoutingError
      end
    end

    context 'admin is signed in' do
      before { sign_in users(:admin) }

      it 'creates the new message' do
        post :create, message: { subject: 'the subject', body: 'the body' }
        assigns(:message).should be_a Message
        assigns(:message).email.should == 'admin@mindhub.org'
        assigns(:message).name.should == 'MindHub Admin'
        assigns(:message).subject.should == 'the subject'
        assigns(:message).body.should == 'the body'
        assigns(:message).should be_valid
        response.should redirect_to admin_path
      end

      context 'message is not valid' do
        let(:message) do
          m = double 'Message'
          m.stub(:email)
          m.stub(:email=)
          m.stub(:name)
          m.stub(:name=)

          m
        end

        before do
          message.should_receive(:valid?).and_return false
          Message.should_receive(:new).and_return message
        end

        it 'flashes and renders :new' do
          post :create, message: { subject: 'the subject', body: 'the body' }

          flash[:error].should == 'Please fill in all fields.'
          response.should render_template 'new'
        end
      end
    end
  end
end
