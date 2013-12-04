HubHub.SignInController = Em.Controller.extend
  email: null
  password: null
  rememberMe: false

  actions:
    signIn: ->
      log.info "SignInController handling signIn event..."

      sayHello = ->
        log.info "HIIII"

      logError = ->
        log.error "Login error!"

      @auth.signIn(
        data:
          session:
            email: @get 'email'
            password: @get 'password'
            remember_me: @get 'rememberMe'
      ).then( -> sayHello() )
      .fail( -> logError() )
