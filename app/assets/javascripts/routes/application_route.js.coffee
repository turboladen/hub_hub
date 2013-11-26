HubHub.ApplicationRoute = Ember.Route.extend
  model: ->
    spokes: @store.find "spoke"
