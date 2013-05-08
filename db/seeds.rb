def create_default_admin
  admin_user = User.create!({
    email: 'admin@mindhub.org',
    first_name: 'Admin',
    last_name: 'the Administrator',
    password: 'creativefresno',
    password_confirmation: 'creativefresno',
    remember_me: false
  })

  admin_user.update_attribute :admin, true
end

def create_listserv_user
  User.create!({
    email: 'list-recipient@chat.mindhub.org',
    first_name: 'list-recipient',
    last_name: 'chat.mindhub.org',
    password: 'creativefresno',
    password_confirmation: 'creativefresno',
    remember_me: false
  })
end

def create_default_spokes
  default_spokes = {
    'Chat' => %{For anything that doesn't fit elsewhere.},
    'Admin' => 'For announcements and questions pertaining to the site.
Please always read messages from the admins!  ...and feel free to post
questions and/or give feedback about the site.',
    'Events' => 'Make an announcement of activities or events in the
community. Please include just the announcement with no lengthy discussion
attached.',
    'Intros' => 'Introduce yourself to the site.',
    'Jobs' =>  'Job postings.',
    'OT' => 'for miscellaneous subjects that are not related to any of the
defined subjects',
    'Politics' => 'for political discussions of various sorts.'
  }

  default_spokes.each do |name, description|
    if spoke = Spoke.find_by_name(name)
      spoke.update_attributes!(description: description)
    else
      Spoke.create!(name: name, description: description)
    end
  end
end

if old_list_user = User.find_by_email('mindhub-list-bounces@list.mindhub.org')
  old_list_user.delete
end

create_default_admin unless User.super_user
create_listserv_user unless User.list_recipient
create_default_spokes

