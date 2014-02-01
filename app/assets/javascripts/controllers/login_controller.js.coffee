HubHub.LoginController = Ember.Controller.extend(Ember.SimpleAuth.LoginControllerMixin,
  authenticator: HubHub.CustomAuthenticator
)
