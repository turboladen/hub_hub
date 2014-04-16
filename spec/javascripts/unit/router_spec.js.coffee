module 'Routing specs',
  setup: -> ({})
  teardown: ->
    HubHub.reset()

test '/, not signed in', ->
  routesTo '/', 'index'

test '/login, not signed in', ->
  routesTo '/login', 'login'

test '/posts, not signed in', ->
  routesTo '/posts', 'posts'

test '/spokes, not signed in', ->
  routesTo '/spokes', 'spokes.index'

test '/sign-out, not signed in', ->
  routesTo '/sign-out', 'sign-out'

test '/registration, not signed in', ->
  routesTo '/registration', 'registration'

test '/tos, not signed in', ->
  routesTo '/tos', 'tos'

test '/faq, not signed in', ->
  routesTo '/faq', 'faq'
