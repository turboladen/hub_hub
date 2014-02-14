HubHub.Response = DS.Model.extend
  body: DS.attr 'string'
  createdAt: DS.attr 'date'
  updatedAt: DS.attr 'date'
  respondableType: DS.attr 'string'
  respondableId: DS.attr 'number'

  # Associations
  owner: DS.belongsTo 'user'
  responses: DS.hasMany 'response', async: true
