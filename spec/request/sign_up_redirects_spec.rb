require 'spec_helper'


describe 'User sign up', type: :request do
  it 'redirects new users to their preference page' do
    get '/users/sign_up'
    response.code.should eq '200'

    expect {
      post user_registration_path, user: {
        first_name: 'Guy1',
        last_name: 'Smiley',
        email: 'guy1@smiley.com',
        password: 'stuff1234',
        password_confirmation: 'stuff1234'
      }
    }.to change { User.count }.by 1

    expect(response).to redirect_to "/users/edit.#{User.last.id}"
    flash[:notice].should == 'Welcome! You have signed up successfully.'
  end
end
