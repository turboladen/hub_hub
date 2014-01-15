HubHub.SpokesRoute = Ember.Route.extend
  model: ->
    @store.find('spoke')
