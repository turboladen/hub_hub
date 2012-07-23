# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Spoke.delete_all
Post.delete_all

#-------------------------------------------------------------------------------
# Fresno
#-------------------------------------------------------------------------------
fresno = Spoke.create(name: 'Fresno', description: %{General Fresno discussion})
fresno.posts.create(name: "Guy Smiley", title: "It's hot today",
  content: "Why don't you come swimming?")
fresno.posts.create(name: "Bert Ernest", title: "Party on the Fulton",
  content: "Come get some Dusty Buns and beer.  MMmmmm aren't you thristy?")
fresno.posts.create(name: "Don", title: "Blackstone is where it's at",
  content: %{I've seen a lot of things in my life, but I've never seen anything
quite like Blackstone avenue.})

#-------------------------------------------------------------------------------
# Grizzlies
#-------------------------------------------------------------------------------
grizzlies = Spoke.create(name: 'Grizzlies', description: %{All about the Fresno Grizzlies})
grizzlies.posts.create(name: "Stephanie", title: "Taco Tuesday",
  content: "Come get some tacos.  They're really tasty and neat and good.")
grizzlies.posts.create(name: "Riki Tiki Tavi", title: "Thirsty Thrusday",
  content: "Come get some beer.  It's good for you; it has vitamins in it.")
grizzlies.posts.create(name: "Guy Smiley", title: "Support your Grizzlies",
  content: %{The Grizzlies play baseball like champions.  Come watch them win!})

#-------------------------------------------------------------------------------
# Art
#-------------------------------------------------------------------------------
art = Spoke.create(name: 'Art', description: %{Sub-community for Fresno artists to
share about shows, gallery openings, and even inspiration})
art.posts.create(name: 'Lisa', title: 'Call to artists',
  content: %q{"California Cityscapes" is the theme of the first Alliance of California Major
 Open Fine Art Show of 2012. This is a great opportunity to step outside of your
comfort zone and recreate that special place. You select the City, Medium and Style!!!
Receiving is February 25th - 10am to 11:30am and the Artist Reception is March 2nd
at the Arts Visalia Gallery - 214 Oak St., Visalia. Please visit the ACA website
for show prospectus details- www.allianceofcaliforniaartists.com
})
art.posts.create(name: 'Tim A Fleming', title: 'Spectrum Gallery Show for July!',
  content: %q{Thursday, July 5    5:00 - 8:00 PM
     ArtHop Mini reception - Dick Haas and Madhu John

Saturday, July 7    2:00 - 5:00 pm
    Artists’ Reception: Dick Haas and Madhu John

Dick Haas “Out to Lunch””  July  5 - 29
 These are images captured as transparencies and, more
recently, digitally.All are photographs taken on the street of people engaged
in reading books or newspapers. Most were taken  while
my wife and I were abroad in various professional capacities.
 The oldest are some 25 years old, the most
recent about 2 years ago. They are from Asia, Eastern
Europe and Russia, China, India, the US and Latin
America. None of the subjects were aware that I had taken
their photograph. Great Art they are not, but my hope is
that viewers will find the people in context of some visual
interest.

Showing with Dack Haas is:

Madhu John - “How to be Alone”
BIO:   I spent my childhood, youth and young adulthood
in the megalopolises of Mumbai and New York.  My first
exposure to photography was through my father, a journalist
and later an environmentalist.  I remember his rolleiflex which
he used extensively on the family and then landmarks and buildings
and eventually on trees and other vegetation.
I suspect it was living in New York city that initiated my
enthusiasm for photography.  everywhere you turned were
visages that provoked and enthralled;  shop windows, people
in a hurry down on fifth avenue or in perfect repose in central park
, Charlie Mingus outside the village vanguard
or Paul Simon on a evening stroll and townhouses and
skyscrapers.  what can a poor boy do if he can’t join a rock
and roll band?  photograph, of course. But the more serious stuff -  decent cameras, a few
workshops, acquiring photo books of winogrand and cartier-
bresson, long hours at moma and the getty, dabbling in wet
darkrooms - all that happened in the last 15 years or so, in
Fresno.  Most often used a 35mm rangefinder and less often
a slr with a long lens  and till 2011, it was analog film.   The
‘breakdown’ happened last year,  it’s a digital rangefinder
for me now, This is a different road, but exciting nevertheless.
THEME:
The original title I had in mind was ‘ you are quite alone’.
too absolute, too emphatic, a little arrogant or pompous, I
thought. so you say, enough of this existential stuff.  Then you
 look around  you see it in magazine covers and
self-help book titles:  How to lose 20 pounds in 30  days,
how to become a millionaire before you turn 35, and in
spam e-mails: how to enlarge certain parts of your anatomy.
hence the new title, so now you know.

})


#-------------------------------------------------------------------------------
# Music
#-------------------------------------------------------------------------------
music = Spoke.create(name: 'Music', description: %{Where to go to find out about
Fresno's music scene})
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


#-------------------------------------------------------------------------------
# Politics
#-------------------------------------------------------------------------------
politics = Spoke.create(name: 'Fresno', description: %{General Fresno discussion})

