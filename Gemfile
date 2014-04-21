source 'https://rubygems.org'
source 'https://rails-assets.org'

ruby '2.1.1'
gem 'rails', '4.1.0'

#-------------------------------------------------------------------------------
# Asset Stuff
#-------------------------------------------------------------------------------
gem 'sass-rails', '~> 4.0.0'
gem 'bootstrap-sass', '~> 3.1.1'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'font-awesome-rails'

gem 'momentjs-rails', '~> 2.5.1'

# gem 'rails-assets-ember-addons.bs_for_ember'
# gem 'rails-assets-ember-admin'
# gem 'rails-assets-epf'


# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Let's use nodejs!

#-------------------------------------------------------------------------------
# Ember-specific
#-------------------------------------------------------------------------------
gem 'ember-rails', '~> 0.14.1'
gem 'ember-data-source', '>= 1.0.0.beta.7'
gem 'ember-source', '~> 1.5.0'
gem 'rails-assets-ember-simple-auth', '~> 0.3.0'


#-------------------------------------------------------------------------------
# View Stuff
#-------------------------------------------------------------------------------
gem 'rails_autolink', '~> 1.1.5'
gem 'kaminari', '~> 0.15.1'
gem 'active_model_serializers'
#gem 'oj', '~> 2.7.3'
#gem 'oj_mimic_json'


#-------------------------------------------------------------------------------
# Web Server Stuff
#-------------------------------------------------------------------------------
gem 'puma', '~> 2.8.0'


#-------------------------------------------------------------------------------
# Database & Object Manipulation
#-------------------------------------------------------------------------------
gem 'pg'


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
  #gem 'rails_12factor'
end

group :development, :test do
  gem 'brakeman'
  gem 'bullet'
  gem 'factory_girl_rails'
  gem 'ffaker'
  gem 'guard-rspec'
  gem 'guard-teaspoon'
  gem 'qunit-rails'
  # Use debugger
  # gem 'debugger', group: [:development, :test]
  gem 'rspec-rails'
  gem 'teaspoon', '~> 0.7.9'
end

group :development do
  gem 'better_errors'
  #gem 'coffee-rails-source-maps'
  gem 'quiet_assets'
  gem 'rack-mini-profiler'
  gem 'rails_best_practices'
  #gem 'sass-rails-source-maps', '~> 0.0.4'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-commands-teaspoon'
end

group :test do
  gem 'database_cleaner', '>= 1.1.1'
  gem 'json_spec'
  gem 'simplecov', require: false
end
