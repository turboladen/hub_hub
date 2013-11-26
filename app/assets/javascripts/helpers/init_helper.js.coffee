HubHub.initApp = (currentUser) ->
  HubHub.__container__.lookup('controller:auth').set 'currentUser', currentUser
