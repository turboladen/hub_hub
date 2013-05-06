require 'spec_helper'


describe SpokesController do
  fixtures :spokes
  fixtures :posts
  fixtures :users

  describe '#index' do
    it 'displays the spokes' do
      get :index

      assigns(:posts).size.should == Post.count

      expect(response.code).to eq '200'
      response.should render_template 'index'
    end

    context 'params[:sort] given but not valid' do
      it 'uses :newest' do
        get :index, sort: 'sdkfljsdk'

        assigns(:sorter).should == 'newest'
        expect(response.code).to eq '200'
      end
    end

    context 'params[:sort] given and is valid' do
      it 'uses the param value' do
        get :index, sort: :most_active

        assigns(:sorter).should == 'most_active'
        expect(response.code).to eq '200'
      end
    end

    context 'params[:sort] not given' do
      it 'uses :newest' do
        get :index

        assigns(:sorter).should == 'newest'
        expect(response.code).to eq '200'
      end
    end
  end

  describe '#show' do
    context '.html' do
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

          assigns(:sorter).should == 'newest'
        end
      end

      context 'params[:sort] given and is valid' do
        it 'uses the param value' do
          get :show, id: spokes(:fresno), sort: :most_active

          assigns(:sorter).should == 'most_active'
        end
      end

      context 'params[:sort] not given' do
        it 'uses :newest' do
          get :show, id: spokes(:fresno)

          assigns(:sorter).should == 'newest'
        end
      end
    end

    context '.rss' do
      pending
    end
  end

  describe '#new' do
    context 'user not signed in' do
      it 'returns a RoutingError' do
        expect { get :new }.to raise_error ActionController::RoutingError
      end
    end

    context 'user signed in but not admin' do
      before { sign_in users(:bob) }

      it 'returns a RoutingError' do
        expect { get :new }.to raise_error ActionController::RoutingError
      end
    end

    context 'admin user signed in' do
      before { sign_in users(:admin) }

      it 'creates a new Spoke and assigns it to @spoke' do
        Spoke.should_receive(:new).and_return 'new spoke'
        get :new
        assigns(:spoke).should == 'new spoke'
      end

      it 'renders the "new" template' do
        get :new

        expect(response.code).to eq '200'
        response.should render_template 'new'
      end
    end
  end

  describe '#edit' do
    context 'user not signed in' do
      it 'returns a RoutingError' do
        expect { get :edit, id: spokes(:fresno).id }.
          to raise_error ActionController::RoutingError
      end
    end

    context 'user signed in but not admin' do
      before { sign_in users(:bob) }

      it 'returns a RoutingError' do
        expect { get :edit, id: spokes(:fresno).id }.
          to raise_error ActionController::RoutingError
      end
    end

    context 'admin user signed in' do
      before { sign_in users(:admin) }

      context 'spoke exists' do
        before do
          get :edit, id: spokes(:fresno).id
        end

        it 'finds the Spoke and assigns it to @spoke' do
          assigns(:spoke).should == spokes(:fresno)
        end

        it 'renders the "edit" template' do
          expect(response.code).to eq '200'
          response.should render_template 'edit'
        end
      end

      context 'spoke does not exist' do
        it 'raises RecordNotFound' do
          expect {
            get :edit, id: 123213123213
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end

  describe '#create' do
    context 'user not signed in' do
      it 'returns a RoutingError' do
        expect { post :create, spoke: { name: 'test', description: 'stuff' } }.
          to raise_error ActionController::RoutingError
      end
    end

    context 'user signed in but not admin' do
      before { sign_in users(:bob) }

      it 'returns a RoutingError' do
        expect { post :create, spoke: { name: 'test', description: 'stuff' } }.
          to raise_error ActionController::RoutingError
      end
    end

    context 'admin user signed in' do
      before { sign_in users(:admin) }

      context 'no spoke info given' do
        it 'renders "new" and flashes' do
          post :create
          flash[:error].should == "Name can't be blank"
          response.should render_template 'new'
        end
      end

      context 'spoke info given' do
        it 'redirects to the Spoke and flashes' do
          post :create, spoke: { name: 'test', description: 'stuff' }
          flash[:notice].should == 'Spoke was successfully created.'
          response.should redirect_to spoke_path(Spoke.find_by_name('test'))
        end
      end
    end
  end

  describe '#update' do
    context 'user not signed in' do
      it 'returns a RoutingError' do
        expect { put :update, spoke: { name: 'test', description: 'stuff' } }.
          to raise_error ActionController::RoutingError
      end
    end

    context 'user signed in but not admin' do
      before { sign_in users(:bob) }

      it 'returns a RoutingError' do
        expect { put :update, spoke: { name: 'test', description: 'stuff' } }.
          to raise_error ActionController::RoutingError
      end
    end

    context 'admin user signed in' do
      before { sign_in users(:admin) }

      context 'no spoke info given for valid Spoke' do
        it 'redirects to the spoke and flashes' do
          put :update, id: spokes(:fresno).id
          flash[:notice].should == 'Spoke was successfully updated.'
          response.should redirect_to spoke_path(spokes(:fresno))
        end
      end

      context 'invalid info given for valid Spoke' do
        it 'redirects to the spoke and flashes' do
          put :update, id: spokes(:fresno).id, pants: 'party'
          flash[:notice].should == 'Spoke was successfully updated.'
          response.should redirect_to spoke_path(spokes(:fresno))
        end
      end

      context 'valid spoke info given' do
        it 'redirects to the spoke and flashes' do
          post :create, spoke: { name: 'test', description: 'stuff' }
          flash[:notice].should == 'Spoke was successfully created.'
          response.should redirect_to spoke_path(Spoke.find_by_name('test'))
        end
      end
    end
  end
end
