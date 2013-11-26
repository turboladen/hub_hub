# for more details see: http://emberjs.com/guides/controllers/

HubHub.NavbarController = Ember.Controller.extend
  needs: ['auth']
  isAuthenticated: Em.computed.alias "controllers.auth.isAuthenticated"
  actions:
    logout: ->
      log.info "NavbarController handling logout event..."
      @get("controllers.auth").logout()

