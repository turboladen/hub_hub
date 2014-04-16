HubHub.Spoke = DS.Model.extend
  name: DS.attr 'string'
  description: DS.attr 'string'

  # Associations
  posts: DS.hasMany 'post', async: true
