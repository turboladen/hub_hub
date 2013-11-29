HubHub.SignOutController = Em.Controller.extend
  actions:
    signOut: ->
      log.info "SignOutController handling signOut event..."

      @auth.signOut(
        data:
          session:
            username: @get 'username'
      ).then -> window.location.reload true
