###
Authorizer that conforms to HubHub's method of authentication
([RFC 6749](http://tools.ietf.org/html/rfc6749)) by adding auth tokens
([RFC 6749](http://tools.ietf.org/html/rfc6750)).

@class CustomAuthorizer
@namespace HubHub
@extends Ember.SimpleAuth.Authorizers.Base
###

###
Authorizes an XHR request by adding the `access_token` property from the
session as an auth token in the `Authorization` header:

```
Authorization: AUTH-TOKEN <token>
```

@method authorize
@param {jqXHR} jqXHR The XHR request to authorize (see http://api.jquery.com/jQuery.ajax/#jqXHR)
@param {Object} requestOptions The options as provided to the `$.ajax` method (see http://api.jquery.com/jQuery.ajaxPrefilter/)
###
HubHub.CustomAuthorizer = SimpleAuth.Authorizers.Base.extend
  authorize: (jqXHR, requestOptions) ->
    log.debug 'Authorizing...'

    authToken = @get('session.authToken')
    authId = @get('session.userId')

    if @get('session.isAuthenticated') and not Ember.isEmpty(authToken) and not Ember.isEmpty(authId)
      unless SimpleAuth.Utils.isSecureUrl(requestOptions.url)
        Ember.Logger.warn "Credentials are transmitted via an insecure connection - use HTTPS to keep them secure."

      jqXHR.setRequestHeader 'Authorization', 'AUTH-TOKEN' + authToken
