# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Hub.delete_all
Post.delete_all

h = Hub.create(name: 'Fresno')
h.posts.create(name: "Guy Smiley", title: "It's hot today",
  content: "Why don't you come swimming?")
h.posts.create(name: "Bert Ernest", title: "Party on the Fulton",
  content: "Come get some Dusty Buns and beer.  MMmmmm aren't you thristy?")

i = Hub.create(name: 'Grizzlies')
i.posts.create(name: "Stephanie", title: "Taco Tuesday",
  content: "Come get some tacos.  They're really tasty and neat and good.")
i.posts.create(name: "Riki Tiki Tavi", title: "Thirsty Thrusday",
  content: "Come get some beer.  It's good for you; it has vitamins in it.")
