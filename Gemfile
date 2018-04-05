source 'https://rubygems.org'

ruby '2.1.4'
gem 'rails', '4.1.7'

#-------------------------------------------------------------------------------
# Asset Stuff
#-------------------------------------------------------------------------------
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'

gem 'momentjs-rails', '~> 2.5.1'

# gem 'rails-assets-ember-addons.bs_for_ember'
# gem 'rails-assets-ember-admin'
# gem 'rails-assets-epf'


# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Let's use nodejs!

#-------------------------------------------------------------------------------
# View Stuff
#-------------------------------------------------------------------------------
gem 'rails_autolink', '~> 1.1.5'
gem 'kaminari', '~> 0.15'
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
gem 'activeadmin', github: 'activeadmin/activeadmin'


#-------------------------------------------------------------------------------
# Deployment
#-------------------------------------------------------------------------------
# gem 'capistrano', group: :development


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  # gem 'sdoc', require: false
end

group :production do
  #gem 'rails_12factor'
end

group :development, :test do
  gem 'brakeman'
  gem 'bullet'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rspec-rails'
end

group :development do
  gem 'better_errors'
  gem 'guard-rspec'
  gem 'quiet_assets'
  gem 'rails_best_practices'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'json_spec'
  gem 'simplecov', require: false
end
