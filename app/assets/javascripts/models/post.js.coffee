HubHub.Post = DS.Model.extend
  title: DS.attr 'string'
  body: DS.attr 'string'
  createdAt: DS.attr 'date'
  updatedAt: DS.attr 'date'

  # Associations
  spoke: DS.belongsTo 'spoke'
  owner: DS.belongsTo 'user', async: true
  responses: DS.hasMany 'response', async: true
