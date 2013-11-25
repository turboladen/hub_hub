HubHub.Post = DS.Model.extend
  title: DS.attr 'string'
  body: DS.attr 'string'

  spoke: DS.belongsTo 'spoke'
