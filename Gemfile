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
gem 'font-awesome-rails'
gem 'ember-rails'
gem 'ember-source'
gem 'ember_script-rails', github: 'ghempton/ember-script-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Let's use nodejs!


#-------------------------------------------------------------------------------
# View Stuff
#-------------------------------------------------------------------------------
gem 'haml-rails'
gem 'rails_autolink', '~> 1.1.5'
gem 'kaminari-bootstrap', github: 'mcasimir/kaminari-bootstrap'


#-------------------------------------------------------------------------------
# Web Server Stuff
#-------------------------------------------------------------------------------
gem 'puma', '~> 2.6.0'


#-------------------------------------------------------------------------------
# Database & Object Manipulation
#-------------------------------------------------------------------------------
gem 'active_model_serializers'


#-------------------------------------------------------------------------------
# Authentication & Authorization
#-------------------------------------------------------------------------------
gem 'devise', '~> 3.1.1'
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
  gem 'rspec-rails'
  gem 'simplecov', require: false
end
