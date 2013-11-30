# ember-auth authentication
HubHub.Auth = Em.Auth.extend

  # Requests to server made via jQuery.ajax()
  request: 'jquery'

  # Server responses sent back as JSON
  response: 'json'

  # Use token auth; expect server responses to return auth_token on new session.
  # Send the token using query params/post data: auth_token=abcd1234.
  strategy: 'token'
  tokenKey: 'auth_token'
  tokenLocation: 'param'

  # Store persistent data in cookies.
  session: 'cookie'

  # Server exposes endpoints:
  signInEndPoint: '/api/sessions'
  signOutEndPoint: '/api/sessions'

  # Server responses return the user's ID as:
  tokenIdKey: 'user_id'

  modules: ['emberData', 'rememberable']

  # We're using ember-data and the ED user model is called 'user'.
  emberData:
    userModel: 'user'

  rememberable:
    tokenKey: 'remember_token'
    period: 7
    autoRecall: true
    endPoint: '/api/remember'
