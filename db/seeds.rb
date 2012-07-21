# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Hub.delete_all
Post.delete_all

fresno = Hub.create(name: 'Fresno')
fresno.posts.create(name: "Guy Smiley", title: "It's hot today",
  content: "Why don't you come swimming?")
fresno.posts.create(name: "Bert Ernest", title: "Party on the Fulton",
  content: "Come get some Dusty Buns and beer.  MMmmmm aren't you thristy?")

grizzlies = Hub.create(name: 'Grizzlies')
grizzlies.posts.create(name: "Stephanie", title: "Taco Tuesday",
  content: "Come get some tacos.  They're really tasty and neat and good.")
grizzlies.posts.create(name: "Riki Tiki Tavi", title: "Thirsty Thrusday",
  content: "Come get some beer.  It's good for you; it has vitamins in it.")

art = Hub.create(name: 'Art')
art.posts.create(name: 'Lisa', title: 'Call to artists',
  content: %q{"California Cityscapes" is the theme of the first Alliance of California Major
 Open Fine Art Show of 2012. This is a great opportunity to step outside of your
comfort zone and recreate that special place. You select the City, Medium and Style!!!
Receiving is February 25th - 10am to 11:30am and the Artist Reception is March 2nd
at the Arts Visalia Gallery - 214 Oak St., Visalia. Please visit the ACA website
for show prospectus details- www.allianceofcaliforniaartists.com
})


music = Hub.create(name: 'Music')
music.posts.create(name: 'Julie', title: 'Love! Chocolate! Music!',
  content: %q{Love Conquers All

Fundraising Concert/Dessert Auction Youth Orchestras of Fresno Sunday February 12, 2012,
7:00pm Paul Shaghoian Concert Hall (Clovis North High School)

Love chocolate? Music? We've got plenty of both this Sunday at the Shaghoian.
Charismatic tenor Scott Piper, who wowed audiences last year at this time with his
passionate-and as needed, comedic-portrayals of favorite opera role,s returns to
Fresno once again to support the Youth Orchestras! He brings along mezzo-soprano
Layna Chianakas, who will join him for some romantic duets in this pre-Valentine's
Day extravaganza.

Come for the fantastic music, stay for the sweet treats and over-the-topdessert
auction. Proceeds benefit the 250 Central Valley youngsters who make our our three orchestras.

Get your tickets now through brownpapertickets.com.

Admission, as always, is FREE for under 18 and/or anyone with a school ID. For this special fundraiser adult tickets are \$25. Premium seats are \$35. Direct link: http://www.brownpapertickets.com/event/212490})
