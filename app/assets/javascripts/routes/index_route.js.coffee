# For more information see: http://emberjs.com/guides/routing/

HubHub.IndexRoute = Ember.Route.extend
  beforeModel: (transition) ->
    @transitionTo 'home'
