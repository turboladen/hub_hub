require 'faker'

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

def create_default_spokes
  default_spokes = {
    'Admin' => %{used by administrators only
for announcements pertaining to MindHub administration. Please always read
these messages.},
    'Events' => %{for making any announcement of activities or events in the
community. Please include just the announcement with no lengthy discussion
attached.},
    'Intro' => %{for self-introductions to the newsgroup.},
    'Jobs' =>  %{for job postings},
    'OT' => %{for miscellaneous subjects that are not related to any of the
defined subjects},
    'Politics' => %{Political discussions of various sorts.}
  }

  default_spokes.each do |name, description|
    unless Spoke.find_by_name(name)
      Spoke.create(name: name, description: description)
    end
  end
end

create_default_admin unless User.find_by_email("admin@mindhub.org")
create_default_spokes

