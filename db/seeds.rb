# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Creates the super user for the site.  Ensures that there's always this admin
# user to get started with (in the case of an empty/new site).
def create_default_admin
  User.create!({
    username: 'admin',
    email: 'admin@mindhub.org',
    first_name: 'Admin',
    last_name: 'the Administrator',
    password: 'creativefresno',
    password_confirmation: 'creativefresno',
    admin: true
  })
end

create_default_admin unless User.find_by email: 'admin@mindhub.org'
