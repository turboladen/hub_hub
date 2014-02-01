HubHub.IndexRoute = Ember.Route.extend
  afterModel: (posts, transition)->
    if @session.isAuthenticated
      props = JSON.parse(@session.store._lastProperties)
      user = @store.find('user', props.user_id)
      @session.set('user', user)
      @transitionTo('posts')
    else
      log.debug 'not logged in'
