HubHub.IndexRoute = Ember.Route.extend
  afterModel: (spokes, transition)->
    if @auth.get('signedIn')
      @transitionTo('spokes')
