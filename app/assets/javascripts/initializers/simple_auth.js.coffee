HubHub.initializer
  name: "authentication"
  after: 'store'

  initialize: (container, application) ->
    application.register 'authenticator:hub_hub', HubHub.CustomAuthenticator
    application.register 'authorizer:hub_hub', HubHub.CustomAuthorizer
    application.inject 'authenticator:hub_hub', 'store', 'store:main'

    Ember.SimpleAuth.setup container, application,
      authorizerFactory: 'authorizer:hub_hub'

    # This needs to come after the call to Ember.SimpleAuth.setup.
    #application.inject 'authenticator:hub_hub', 'session', 'session:main'
