# for more details see: http://emberjs.com/guides/controllers/

HubHub.WelcomeMsgController = Ember.Controller.extend
  needs: ['auth']
  isAuthenticated: Em.computed.alias "controllers.auth.isAuthenticated"
  user: Em.computed.alias "controllers.auth.currentUser"
  hiName: Em.computed.any "user.name","user.email"

