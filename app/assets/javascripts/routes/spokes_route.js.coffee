# For more information see: http://emberjs.com/guides/routing/

HubHub.SpokesRoute = Ember.Route.extend
  model: ->
    @store.find('spoke')
