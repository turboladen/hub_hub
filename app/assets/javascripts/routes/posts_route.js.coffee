# For more information see: http://emberjs.com/guides/routing/

HubHub.PostsRoute = Ember.Route.extend
  model: ->
    @store.find 'post'
