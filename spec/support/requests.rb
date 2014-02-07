RSpec.configure do |config|
  config.include Requests::SessionHelpers, type: :request
end
