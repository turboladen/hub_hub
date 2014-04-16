HubHub.Store = DS.Store.extend({})

# Tell Ember to prepend /api to calls to the JSON API.
HubHub.ApplicationAdapter = DS.ActiveModelAdapter.reopen
  namespace: 'api'
