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
    'Chat' => %{for anything that doesn't fit elsewhere.},
    'Admin' => %{used by administrators only
for announcements pertaining to MindHub administration. Please always read
these messages.},
    'Events' => %{for making any announcement of activities or events in the
community. Please include just the announcement with no lengthy discussion
attached.},
    'Intros' => %{for self-introductions to the newsgroup.},
    'Jobs' =>  %{for job postings},
    'OT' => %{for miscellaneous subjects that are not related to any of the
defined subjects},
    'Politics' => %{Political discussions of various sorts.}
  }

  default_spokes.each do |name, description|
    unless Spoke.find_by_name(name)
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

