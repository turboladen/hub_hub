require 'spec_helper'


describe AdminController do
  fixtures :users
  fixtures :posts

  describe '#index' do
    context 'user not logged in' do
      it 'raises' do
        expect { get :index }.to raise_error ActionController::RoutingError
      end
    end

    context 'user logged in but not admin' do
      before { sign_in users(:bob) }

      it 'raises' do
        expect { get :index }.to raise_error ActionController::RoutingError
      end
    end

    context 'admin logged' do
      before { sign_in users(:admin) }

      it 'redirects to the admin users path' do
        expect { get :index }.to_not raise_error ActionController::RoutingError

        expect(response).to redirect_to admin_users_path
      end
    end
  end

  describe '#inapprpriate_items' do
    context 'user not logged in' do
      it 'raises' do
        expect {
          get :inappropriate_items, { flaggable_type: 'posts' }
        }.to raise_error ActionController::RoutingError
      end
    end

    context 'user logged in but not admin' do
      before { sign_in users(:bob) }

      it 'raises' do
        expect {
          get :inappropriate_items, { flaggable_type: 'posts' }
        }.to raise_error ActionController::RoutingError
      end
    end

    context 'admin logged' do
      before { sign_in users(:admin) }

      it 'renders the flagged items' do
        users(:bob).flag(posts(:post_one), :inappropriate)

        get :inappropriate_items, { flaggable_type: 'posts' }

        assigns(:flags_and_posts).should_not be_nil
        assigns(:flags_and_posts).should_not be_empty
        response.should render_template 'admin/flaggings/index'
      end
    end
  end
end
