require 'spec_helper'


describe 'Admin user flows', type: :response do
  fixtures :all

  it 'lets and admin make another user an admin' do
    admin = login :super_user
    admin.get '/admin/users'
    admin.response.code.should eq '200'

    admin.xhr :put, "/admin/users/#{users(:bob).id}", id: users(:bob).id,
      "#{users(:bob).id}-is-admin" => 'true'

    admin.response.code.should eq '200'
    User.find(users(:bob).id).should be_admin

    bob = login :bob
    expect { bob.get '/admin/users' }.to_not raise_exception

    bob.response.code.should eq '200'
  end

  it 'lets an admin make another admin a regular user' do
    users(:bob).update_attribute :admin, true

    admin = login :super_user
    admin.get '/admin/users'
    admin.response.code.should eq '200'

    admin.xhr :put, "/admin/users/#{users(:bob).id}", id: users(:bob).id,
      "#{users(:bob).id}-is-admin" => 'false'
    admin.response.code.should eq '200'

    bob = login :bob
    expect {
      bob.get 'admin/users'
    }.to raise_error ActionController::RoutingError

    bob.response.code.should eq '302'
  end

  it 'lets an admin bad a regular logged-in user' do
    users(:bob).should_not be_banned
    bob = login :bob

    admin = login :super_user
    admin.get '/admin/users'
    admin.response.code.should eq '200'

    admin.xhr :put, "/admin/users/#{users(:bob).id}", id: users(:bob).id,
      "#{users(:bob).id}-is-banned" => 'true'
    admin.response.code.should eq '200'

    bob.get '/home/index'
    bob.flash[:alert].should == 'You are banned from this site.'
  end

  it 'lets an admin unban a regular user' do
    users(:bob).update_attribute :banned, true

    admin = login :super_user
    admin.get '/admin/users'
    admin.response.code.should eq '200'

    admin.xhr :put, "/admin/users/#{users(:bob).id}", id: users(:bob).id,
      "#{users(:bob).id}-is-banned" => 'false'
    admin.response.code.should eq '200'

    bob = login :bob
    bob.get '/home/index'
    bob.response.code.should eq '200'
    bob.flash[:alert].should be_nil
  end
end
