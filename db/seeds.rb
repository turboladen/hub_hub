require 'faker'

Spoke.delete_all
Post.delete_all
Comment.delete_all

def create_default_admin
  admin_user = User.create({
    email: 'admin@mindhub.org',
    first_name: 'Admin',
    last_name: 'the Administrator',
    password: 'creativefresno',
    password_confirmation: 'creativefresno',
    remember_me: false
  })
  admin_user.update_attribute :admin, true
end

if User.count.zero?
  create_default_admin

  6.times do
    users << User.create({
      email: Faker::Internet.email,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      password: 'password',
      password_confirmation: 'password',
      remember_me: false
    })
  end
else
  create_default_admin unless User.find_by_email("admin@mindhub.org")
end

users = User.all

#-------------------------------------------------------------------------------
# Admin
#-------------------------------------------------------------------------------
admin = Spoke.create(name: 'Admin', description: %{used by administrators only
  for announcements pertaining to MindHub administration. Please always read
  these messages.})

a_posts = []
a_posts << admin.posts.build(title: "Rule #1", content: "Don't do stupid stuff.")

#-------------------------------------------------------------------------------
# Event
#-------------------------------------------------------------------------------
event = Spoke.create(name: 'Events', description: %{for making any announcement
  of activities or events in the community. Please include just the announcement
  with no lengthy discussion attached.})

e_posts = []
e_posts << event.posts.build(title: "It's hot today", content: "Why don't you come swimming?")
e_posts << event.posts.build(title: "September Blender: Shepherd's Inn",
  content: "http://creativefresno.ning.com/events/september-blender-shepherds")

e_posts << event.posts.build(title: "WEDNESDAY - MARKET ON KERN STREET",
  content: %[Hello Hubbers!

Once again the Market on Kern Street is back! We hope you all had a great
Independence Day. Mark your calendar for Wednesday 11, 2012. Every
Wednesday you are welcome to attend from 10 am - 2 pm.

Buy fresh produce, enjoy live music, purchase prepared foods, and support
local artisans .

WEDNESDAY is certainly the Best Day of the Week!

For more information visit the office or give us a call.

845 Fulton Mall
Fresno, CA 93721
559.490.9966
www.downtownfresno.org])

e_posts << event.posts.build(title: "Party on the Fulton",
  content: "Come get some Dusty Buns and beer.  MMmmmm aren't you thristy?")

e_posts << event.posts.build(title: "Blackstone is where it's at",
  content: %{I've seen a lot of things in my life, but I've never seen anything
quite like Blackstone avenue.})
e_posts.each { |post| post.user = users.sample; post.save! }

10.times do |i|
  tmp_post = e_posts.sample
  parent_comment = Comment.build_from(tmp_post, users.sample.id, Faker::Lorem.paragraph)
  parent_comment.save!

  nested_comment = Comment.build_from(tmp_post, users.sample.id, Faker::Lorem.paragraph)
  nested_comment.save!
  nested_comment.move_to_child_of(parent_comment)

  if i % 4
    nested_comment2 = Comment.build_from(tmp_post, users.sample.id, Faker::Lorem.paragraph)
    nested_comment2.save!
    nested_comment2.move_to_child_of(nested_comment)
  end
end

7.times do
  e_posts.sample.liked_by users.sample
end

4.times do
  e_posts.sample.disliked_by users.sample
end

3.times do
  users.sample.toggle_flag(e_posts.sample, :inappropriate)
  users.sample.toggle_flag(e_posts.sample, :favorite)
end

#-------------------------------------------------------------------------------
# Intro
#-------------------------------------------------------------------------------
intro = Spoke.create(name: 'Intros', description: %{for self-introductions to the newsgroup.})

i_posts = []
i_posts << intro.posts.build(title: "Taco Tuesday",
  content: "Come get some tacos.  They're really tasty and neat and good.")
i_posts << intro.posts.build(title: "Thirsty Thrusday",
  content: "Come get some beer.  It's good for you; it has vitamins in it.")
i_posts << intro.posts.build(title: "Support your Grizzlies",
  content: %{The Grizzlies play baseball like champions.  Come watch them win!})
i_posts.each { |post| post.user = users.sample; post.save! }

12.times do |i|
  tmp_post = i_posts.sample
  parent_comment = Comment.build_from(tmp_post, users.sample.id, Faker::Lorem.paragraph)
  parent_comment.save!

  nested_comment = Comment.build_from(tmp_post, users.sample.id, Faker::Lorem.paragraph)
  nested_comment.save!
  nested_comment.move_to_child_of(parent_comment)

  if i % 5
    nested_comment = Comment.build_from(tmp_post, users.sample.id, Faker::Lorem.paragraph)
    nested_comment.save!
    nested_comment.move_to_child_of(parent_comment)
  elsif
    nested_comment2 = Comment.build_from(tmp_post, users.sample.id, Faker::Lorem.paragraph)
    nested_comment2.save!
    nested_comment2.move_to_child_of(nested_comment)
  end
end

5.times do
  i_posts.sample.liked_by users.sample
end

1.times do
  users.sample.toggle_flag(i_posts.sample, :inappropriate)
  users.sample.toggle_flag(i_posts.sample, :favorite)
end

#-------------------------------------------------------------------------------
# Art
#-------------------------------------------------------------------------------
job_postings = Spoke.create(name: 'Jobs', description: %{for job postings})
a_posts = []
a_posts << job_postings.posts.build(title: 'Call to artists',
  content: %q{"California Cityscapes" is the theme of the first Alliance of California Major
 Open Fine Art Show of 2012. This is a great opportunity to step outside of your
comfort zone and recreate that special place. You select the City, Medium and Style!!!
Receiving is February 25th - 10am to 11:30am and the Artist Reception is March 2nd
at the Arts Visalia Gallery - 214 Oak St., Visalia. Please visit the ACA website
for show prospectus details- www.allianceofcaliforniaartists.com
})
a_posts << job_postings.posts.build(title: 'Spectrum Gallery Show for July!',
  content: %q{Thursday, July 5    5:00 - 8:00 PM
     ArtHop Mini reception - Dick Haas and Madhu John

Saturday, July 7    2:00 - 5:00 pm
    Artists' Reception: Dick Haas and Madhu John

Dick Haas "Out to Lunch"  July  5 - 29
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

Madhu John - "How to be Alone"
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
skyscrapers.  what can a poor boy do if he can't join a rock
and roll band?  photograph, of course. But the more serious stuff -  decent cameras, a few
workshops, acquiring photo books of winogrand and cartier-
bresson, long hours at moma and the getty, dabbling in wet
darkrooms - all that happened in the last 15 years or so, in
Fresno.  Most often used a 35mm rangefinder and less often
a slr with a long lens  and till 2011, it was analog film.   The
'breakdown' happened last year,  it's a digital rangefinder
for me now, This is a different road, but exciting nevertheless.
THEME:
The original title I had in mind was ' you are quite alone'.
too absolute, too emphatic, a little arrogant or pompous, I
thought. so you say, enough of this existential stuff.  Then you
 look around  you see it in magazine covers and
self-help book titles:  How to lose 20 pounds in 30  days,
how to become a millionaire before you turn 35, and in
spam e-mails: how to enlarge certain parts of your anatomy.
hence the new title, so now you know.

})

a_posts.each { |post| post.user = users.sample; post.save! }

10.times do
  Comment.build_from(a_posts.sample, users.sample.id, Faker::Lorem.paragraph).save!
end

1.times do
  users.sample.toggle_flag(a_posts.sample, :inappropriate)
  users.sample.toggle_flag(a_posts.sample, :favorite)
end

#-------------------------------------------------------------------------------
# OT
#-------------------------------------------------------------------------------
ot = Spoke.create(name: 'OT', description: %{for miscellaneous subjects that
are not related to any of the defined subjects})

o_posts = []
o_posts << ot.posts.build(title: 'Love! Chocolate! Music!',
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

o_posts.each { |post| post.user = users.sample; post.save! }

10.times do
  Comment.build_from(o_posts.sample, users.sample.id, Faker::Lorem.paragraph).save!
end

2.times do
  o_posts.sample.liked_by users.sample
end

2.times do
  o_posts.sample.disliked_by users.sample
end

1.times do
  users.sample.toggle_flag(o_posts.sample, :inappropriate)
  users.sample.toggle_flag(o_posts.sample, :favorite)
end

#-------------------------------------------------------------------------------
# Politics
#-------------------------------------------------------------------------------
politics = Spoke.create(name: 'Politics', description: %{Political discussions of various sorts.})

p_posts = []
p_posts << politics.posts.build(title: "This is a cool house", content: "http://whitehouse.gov")
p_posts << politics.posts.build(title: "Mitt Romney", content: "is a guy.")

p_posts.each { |post| post.user = users.sample; post.save! }

50.times do
  Comment.build_from(p_posts.sample, users.sample.id, Faker::Lorem.paragraph).save!
end

71.times do
  p_posts.sample.liked_by users.sample
end

49.times do
  p_posts.sample.disliked_by users.sample
end

1.times do
  users.sample.toggle_flag(p_posts.sample, :inappropriate)
  users.sample.toggle_flag(p_posts.sample, :favorite)
end

