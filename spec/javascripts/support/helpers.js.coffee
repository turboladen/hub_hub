Ember.Test.registerHelper 'currentRoute', ->
  HubHub.__container__.lookup('controller:application').currentRouteName

#Ember.Test.registerHelper 'stubSignedIn', ->
#  App.__container__.lookup('session:current').set('authToken', 'test_token')

# Sets an expectation that the current route will be +route+.
Ember.Test.registerHelper 'expectRoute', (app, route) ->
  cr = currentRoute()
  message = "Expected '#{route}', got: '#{cr}'"
  equal(cr, route, message)

# Makes it easy to write routing specs.
#
# @param url [String] The URL to visit.
# @param route [String] The route you should end up on.
Ember.Test.registerHelper 'routesTo', (app, url, route) ->
  visit(url)
  andThen ->
    expectRoute(route)
