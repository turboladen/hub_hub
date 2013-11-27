HubHub.Post = DS.Model.extend
  title: DS.attr 'string'
  body: DS.attr 'string'
  createdAt: DS.attr 'date'
  updatedAt: DS.attr 'date'

  spoke: DS.belongsTo 'spoke'
  owner: DS.belongsTo 'user'
