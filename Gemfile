source 'https://rubygems.org'

ruby '2.0.0'
gem 'rails', '4.0.1'

#-------------------------------------------------------------------------------
# Asset Stuff
#-------------------------------------------------------------------------------
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'bootstrap-sass-rails', '~> 3.0.1.0'
gem 'font-awesome-sass'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Let's use nodejs!

#-------------------------------------------------------------------------------
# Ember-specific
#-------------------------------------------------------------------------------
gem 'ember-rails', '~> 0.14.1'
gem 'ember-data-source', '>= 1.0.0.beta.3'
gem 'ember-source', '~> 1.2.0'
gem 'ember-auth-rails'
gem 'ember-auth-source', '~> 9.0.7'
gem 'ember-auth-module-action_redirectable-rails'
gem 'ember-auth-module-action_redirectable-source', '~> 1.0.2'
gem 'ember-auth-module-ember_data-rails'
gem 'ember-auth-module-ember_data-source', '~> 1.0.2'
gem 'ember-auth-module-rememberable-rails'
gem 'ember-auth-module-rememberable-source', '~> 1.0.3'
gem 'ember-auth-request-jquery-rails'
gem 'ember-auth-request-jquery-source', '~> 1.0.3'
gem 'ember-auth-response-json-rails'
gem 'ember-auth-response-json-source', '~> 1.0.2'
gem 'ember-auth-strategy-token-rails'
gem 'ember-auth-strategy-token-source', '~> 1.0.2'
gem 'ember-auth-session-cookie-rails'
gem 'ember-auth-session-cookie-source', '~> 1.0.1'


#-------------------------------------------------------------------------------
# View Stuff
#-------------------------------------------------------------------------------
gem 'rails_autolink', '~> 1.1.5'
gem 'kaminari-bootstrap', github: 'mcasimir/kaminari-bootstrap'


#-------------------------------------------------------------------------------
# Web Server Stuff
#-------------------------------------------------------------------------------
gem 'puma', '~> 2.6.0'


#-------------------------------------------------------------------------------
# Database & Object Manipulation
#-------------------------------------------------------------------------------
gem 'pg'
gem 'active_model_serializers'


#-------------------------------------------------------------------------------
# Authentication & Authorization
#-------------------------------------------------------------------------------
gem 'bcrypt-ruby', '~> 3.1.2'
gem 'cancan', '~> 1.6.10'


#-------------------------------------------------------------------------------
# Administration
#-------------------------------------------------------------------------------
gem 'activeadmin', github: 'gregbell/active_admin'


#-------------------------------------------------------------------------------
# Deployment
#-------------------------------------------------------------------------------
# gem 'capistrano', group: :development


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :production do
  gem 'mysql2'
  #gem 'rails_12factor'
end

group :development, :test do
  gem 'brakeman'
  gem 'bullet'
  gem 'factory_girl_rails'
  gem 'ffaker'
  gem 'qunit-rails'
  gem 'sqlite3'
  # Use debugger
  # gem 'debugger', group: [:development, :test]
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'quiet_assets'
  gem 'rack-mini-profiler'
  gem 'rails_best_practices'
end

group :test do
  gem 'database_cleaner', '>= 1.1.1'
  gem 'json_spec'
  gem 'rspec-rails'
  gem 'simplecov', require: false
end
