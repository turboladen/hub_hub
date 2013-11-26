# For more information see: http://emberjs.com/guides/routing/

HubHub.RegistrationRoute = Ember.Route.extend({
  model: -> Ember.Object.create()
  actions:
    register: ->
      log.info "Registering..."
      @controllerFor("auth").register this
    cancel: ->
      log.info "cancelling registration"
      @transitionTo 'home'
})
