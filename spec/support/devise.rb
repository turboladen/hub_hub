
module RequestHelpers
  def login(user)
    ActionController::IntegrationTest.new(self).open_session do |sess|
      u = users(user)

      sess.post '/users/sign_in', {
        user: {
          email: u.email,
          password: 'password'
        }
      }

      sess.flash[:alert].should be_nil
      sess.flash[:notice].should == 'Signed in successfully.'
      sess.response.code.should == '302'
    end
  end
end

include RequestHelpers

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include RequestHelpers, type: :request
end
