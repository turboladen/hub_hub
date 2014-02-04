HubHub.IndexRoute = Ember.Route.extend
  afterModel: (posts, transition)->
    if @session.isAuthenticated
      @transitionTo('posts')
    else
      log.debug 'not logged in'
