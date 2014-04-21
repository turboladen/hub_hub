HubHub.LoginController = Ember.Controller.extend(Ember.SimpleAuth.LoginControllerMixin,
  authenticatorFactory: 'authenticator:hub_hub'
)
