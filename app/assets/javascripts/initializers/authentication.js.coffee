HubHub.initializer
  name: 'authentication'
  before: 'simple-auth'
  after: 'store'

  initialize: (container, application) ->
    application.register 'authenticator:hub_hub', HubHub.CustomAuthenticator
    application.register 'authorizer:hub_hub', HubHub.CustomAuthorizer
    application.inject 'authenticator:hub_hub', 'store', 'store:main'

window.ENV ?= {}
window.ENV['simple-auth'] =
  authorizer: 'authorizer:hub_hub'
  #authenticationRoute: 'login'
  #routeAfterAuthentication: 'growers',
