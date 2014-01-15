HubHub.SignOutController = Em.Controller.extend
  actions:
    signOut: ->
      log.info "SignOutController handling signOut event..."

      @auth.signOut(
        # This doesn't seem to be doing anything now... is that a bug on ember-auth?
        data:
          session:
            auth_token: @auth.get 'authToken'
      ).then -> window.location.reload true
