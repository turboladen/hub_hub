# for more details see: http://emberjs.com/guides/models/defining-models/

HubHub.User = DS.Model.extend
  # Core properties
  username: DS.attr 'string'
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

