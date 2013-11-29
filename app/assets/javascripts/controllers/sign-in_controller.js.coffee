HubHub.SignInController = Em.Controller.extend
  username: null
  password: null
  rememberMe: false

  actions:
    signIn: ->
      log.info "SignInController handling signIn event..."
      @auth.signIn(
        data:
          session:
            username: @get 'username'
            password: @get 'password'
            remember_me: @get 'rememberMe'
      ).then( -> sayHello() )
      .fail( -> logError() )
