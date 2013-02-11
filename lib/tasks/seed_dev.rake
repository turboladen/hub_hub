namespace :db do
  desc "Seeds the DB with test data from db/seeds_dev.rb"
  task :seed_dev do
    require_relative '../../db/seeds_dev'
  end
end
