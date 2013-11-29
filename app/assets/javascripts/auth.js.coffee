# ember-auth authentication
HubHub.Auth = Em.Auth.extend
  modules: ['emberData', 'rememberable']
  emberData:
    userModel: 'user'
  rememberable:
    tokenKey: 'remember_me'
    period: 7
    autoRecall: true

  request: 'jquery'
  response: 'json'
  session: 'cookie'
  signInEndPoint: '/api/sessions'
  signOutEndPoint: '/api/sessions'
  strategy: 'token'
  tokenIdKey: 'user_id'
  tokenKey: 'auth_token'
  tokenLocation: 'param'
