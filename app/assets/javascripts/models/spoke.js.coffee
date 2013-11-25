HubHub.Spoke = DS.Model.extend
  name: DS.attr 'string'
  description: DS.attr 'string'

  posts: DS.hasMany 'post', async: true
