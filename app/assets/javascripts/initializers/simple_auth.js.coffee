Ember.Application.initializer
  name: "authentication"
  initialize: (container, application) ->
    Ember.SimpleAuth.setup application,
      authorizer: HubHub.CustomAuthorizer
