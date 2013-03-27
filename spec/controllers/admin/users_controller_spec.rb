require 'spec_helper'


describe Admin::UsersController do
  fixtures :users

  let(:bob) { users(:bob) }
  let(:admin) { users(:admin) }

  describe '#index' do
    context 'user not signed in' do
      it 'raises' do
        expect { get :index }.to raise_error ActionController::RoutingError
      end
    end

    context 'user signed in but not admin' do
      before { sign_in bob }

      it 'raises' do
        expect { get :index }.to raise_error ActionController::RoutingError
      end
    end

    context 'admin signed in' do
      before { sign_in admin }

      it 'gets the users and renders index' do
        get :index
        assigns(:users).should == User.all
        response.should render_template 'index'
      end
    end
  end

  describe '#edit' do
    context 'user not signed in' do
      it 'raises' do
        expect { get :edit, id: bob.id }.to raise_error ActionController::RoutingError
      end
    end

    context 'user signed in but not admin' do
      before { sign_in bob }

      it 'raises' do
        expect { get :edit, id: bob.id }.to raise_error ActionController::RoutingError
      end
    end

    context 'admin signed in' do
      before { sign_in admin }

      it 'gets the user and renders edit' do
        get :edit, id: bob.id

        assigns(:user).should == bob
        response.should render_template 'edit'
      end
    end
  end

  describe '#update' do
    context 'user not signed in' do
      it 'raises' do
        expect {
          xhr :put, :update, id: bob.id, "#{bob.id}-is-admin" => 'true'
        }.to raise_error ActionController::RoutingError
      end
    end

    context 'user signed in but not admin' do
      before { sign_in bob }

      it 'raises' do
        expect {
          xhr :put, :update, id: bob.id, "#{bob.id}-is-admin" => 'true'
        }.to raise_error ActionController::RoutingError
      end
    end

    context 'admin signed in' do
      before { sign_in admin }

      context 'user ID is for the super user' do
        let(:su) { users(:super_user) }

        it 'redirects to admin home and flashes and error' do
          xhr :put, :update, id: su.id, "#{su.id}-is-admin" => 'false'

          assigns(:user).should == su
          flash[:error].should == "Can't update super-user."
          expect(response).to redirect_to admin_url
        end

        it 'redirects to admin home and flashes and error' do
          xhr :put, :update, id: su.id, "#{su.id}-is-banned" => 'true'

          assigns(:user).should == su
          flash[:error].should == "Can't update super-user."
          expect(response).to redirect_to admin_url
        end
      end

      context 'user ID is for a regular user' do
        context 'with userid-is-admin' do
          it 'makes the user an admin' do
            xhr :put, :update, id: bob.id, "#{bob.id}-is-admin" => 'true'

            assigns(:user).should == users(:bob)
            response.code.should eq '200'
            response.should render_template 'admin/users/update_admin'
            User.find(bob).should be_admin
          end
        end

        context 'with userid-is-banned' do
          it 'can bans the user' do
            xhr :put, :update, id: bob.id, "#{bob.id}-is-banned" => 'true'

            assigns(:user).should == users(:bob)
            response.code.should eq '200'
            response.should render_template 'admin/users/update_ban'
            User.find(bob).should be_banned
          end

          it 'can unban the user' do
            bob.banned = true
            bob.save
            xhr :put, :update, id: bob.id, "#{bob.id}-is-banned" => 'false'

            assigns(:user).should == users(:bob)
            response.code.should eq '200'
            response.should render_template 'admin/users/update_ban'
            User.find(bob).should_not be_banned
          end
        end
      end

      context 'user ID is for an admin' do
        context 'with userid-is-admin' do
          it 'makes the admin a regular user' do
            xhr :put, :update, id: admin.id, "#{admin.id}-is-admin" => 'false'

            assigns(:user).should == users(:admin)
            response.code.should eq '200'
            response.should render_template 'admin/users/update_admin'
            User.find(admin).should_not be_admin
          end
        end

        context 'with userid-is-banned' do
          it 'bans the admin' do
            xhr :put, :update, id: admin.id, "#{admin.id}-is-banned" => 'true'

            assigns(:user).should == users(:admin)
            response.code.should eq '200'
            response.should render_template 'admin/users/update_ban'
            User.find(admin).should be_banned
          end
        end
      end
    end
  end
end
