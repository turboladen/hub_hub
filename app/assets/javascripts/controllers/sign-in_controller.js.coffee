HubHub.SignInController = Em.Controller.extend
  email: null
  password: null
  rememberMe: false

  actions:
    signIn: ->
      log.info "SignInController handling signIn event..."
      @auth.signIn(
        data:
          session:
            email: @get 'email'
            password: @get 'password'
            remember_me: @get 'rememberMe'
      ).then( -> sayHello(
        log.info "Saying hi after login..."
      ) )
      .fail( -> logError(
          unless @auth.signedIn
            log.error "Login error!"
        ) )
