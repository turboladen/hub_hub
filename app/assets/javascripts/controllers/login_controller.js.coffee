HubHub.LoginController = Ember.Controller.extend(SimpleAuth.LoginControllerMixin,
  authenticatorFactory: 'authenticator:hub_hub'
)
