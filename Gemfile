source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Database
gem 'ledermann-rails-settings', '~> 1.2.1', require: 'rails-settings'

group :production do
  gem 'mysql2'
  #gem 'pg'  # for heroku
  gem 'passenger'
  #gem 'unicorn'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'bootstrap-sass', '~> 2.0.4.2'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'

  gem 'turbo-sprockets-rails3'
end

gem 'haml-rails', '~> 0.3.4'
gem 'jquery-rails'

# For CSS in HTML emails
gem 'premailer-rails'

# Model Plugins
gem 'devise'
gem 'acts_as_commentable_with_threading', '~> 1.1.2'
gem 'acts_as_votable', '~> 0.4.0'
gem 'make_flaggable', git: 'git://github.com/cavneb/make_flaggable.git'
gem 'permanent_records'
gem 'friendly_id', '~> 4.0.9'

# Other Plugins
gem 'twitter', '~> 4.2.0'
gem 'whenever', '~> 0.8.0', require: false
gem 'kaminari', '~> 0.14.1'
gem 'kaminari-bootstrap'
gem 'sanitize'
gem 'rails_autolink', '~> 1.0.9'
gem 'nokogiri'
gem 'premailer-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Deploy with Capistrano
gem 'capistrano'
#gem 'drama', path: '../drama'
#gem 'drama-parts', path: '../drama-parts'

# To use debugger
# gem 'debugger'

group :deploy do
  gem 'screenplay', git: 'git@github.com:turboladen/screenplay.git'
  gem 'rosh', git: 'git@github.com:turboladen/rosh.git'
end

group :development, :test do
  gem 'brakeman'
  gem 'ffaker'
  gem 'mailcatcher'
  gem 'rails_best_practices'
  gem 'rspec-rails', '~> 2.0'
  gem 'simplecov', require: false, group: :test
  gem 'sqlite3'
  gem 'tailor'
  gem 'test-unit'
  gem 'vagrant', '>= 1.0.0'
  gem 'vagrant-ansible'
end

gem 'bundler'
