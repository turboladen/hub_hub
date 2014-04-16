HubHub.User = DS.Model.extend
  # Core properties
  email: DS.attr 'string'
  firstName: DS.attr 'string'
  lastName: DS.attr 'string'
  isAdmin: DS.attr 'boolean'
  isBanned: DS.attr 'boolean'

  # Auth
  param: DS.attr 'string'

  # Associations
  posts: DS.hasMany 'post', async: true

  # Computed properties
  fullName: (->
    @get('firstName') + ' ' + @get('lastName')
  ).property('firstName', 'lastName')

HubHub.Owner = HubHub.User.extend({})
