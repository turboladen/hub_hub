HubHub.NavigationController = Ember.Controller.extend
  actions:
    signOut: ->
      log.info "NavbarController handling logout event..."
      @controllerFor('sign-out').send('signOut')

