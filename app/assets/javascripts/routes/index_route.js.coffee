HubHub.IndexRoute = Ember.Route.extend
  afterModel: (posts, transition)->
    if @auth.get('signedIn')
      @transitionTo('posts')
