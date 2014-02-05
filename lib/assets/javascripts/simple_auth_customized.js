/**
 Authenticator that conforms to HubHub's session auth.

 This authenticator supports refreshing the access token automatically and
 will trigger the `'ember-simple-auth:session-updated'` event each time the
 token was refreshed.

 @class CustomAuthenticator
 @namespace HubHub
 @extends Ember.SimpleAuth.Authenticators.Base
 */
HubHub.CustomAuthenticator = Ember.SimpleAuth.Authenticators.Base.extend({
    /**
     The endpoint on the server the authenticator acquires the access token
     from.

     @property serverTokenEndpoint
     @type String
     @default '/api/sessions'
     */
    serverTokenEndpoint: '/api/sessions',

    /**
     Sets whether the authenticator automatically refreshes access tokens.

     @property refreshAccessTokens
     @type Boolean
     @default true
     */
    refreshAccessTokens: true,

    /**
     @property _refreshTokenTimeout
     @private
     */
    _refreshTokenTimeout: null,

    /**
     Restores the session from a set of session properties; __will return a
     resolving promise when there's a non-empty `access_token` in the
     `properties`__ and a rejecting promise otherwise.

     This method also schedules automatic token refreshing when there are values
     for `refresh_token` and `expires_in` in the `properties` and automatic
     token refreshing isn't disabled (see
     [Ember.SimpleAuth.Authenticators.OAuth2#refreshAccessTokens](#Ember-SimpleAuth-Authenticators-OAuth2-refreshAccessTokens)).

     @method restore
     @param {Object} properties The properties to restore the session from
     @return {Ember.RSVP.Promise} A promise that when it resolves results in the session being authenticated
     */
    restore: function(properties) {
        var _this = this;
        _this._setUser(properties.user_id);

        return new Ember.RSVP.Promise(function(resolve, reject) {
            if (!Ember.isEmpty(properties.access_token)) {
                _this.scheduleAccessTokenRefresh(properties.expires_in, properties.refresh_token);
                resolve(properties);
            } else {
                reject();
            }
        });
    },

    /**
     Authenticates the session with the specified `credentials`; the credentials
     are `POST`ed to the `serverTokenEndpoint` and if they are valid the server
     returns an access token in response (see
     http://tools.ietf.org/html/rfc6749#section-4.3). __If the credentials are
     valid and authentication succeeds, a promise that resolves with the
     server's response is returned__, otherwise a promise that rejects with the
     error is returned.

     This method also schedules automatic token refreshing when there are values
     for `refresh_token` and `expires_in` in the server response and automatic
     token refreshing isn't disabled (see
     [Ember.SimpleAuth.Authenticators.OAuth2#refreshAccessTokens](#Ember-SimpleAuth-Authenticators-OAuth2-refreshAccessTokens)).

     @method authenticate
     @param {Object} options The credentials to authenticate the session with
     @return {Ember.RSVP.Promise} A promise that resolves when an access token is successfully acquired from the server and rejects otherwise
     */
    authenticate: function(credentials) {
        Ember.Logger.debug('MEOW: authenticating');
        var _this = this;
        return new Ember.RSVP.Promise(function(resolve, reject) {
            var data = { email: credentials.identification, password: credentials.password };
            _this.makeRequest(data).then(function(response) {
                Ember.run(function() {
                    _this.scheduleAccessTokenRefresh(response.expires_in, response.refresh_token);
                    _this._setUser(response.user_id);
                    resolve(response);
                });
            }, function(xhr, status, error) {
                Ember.run(function() {
                    reject(xhr.responseText);
                });
            });
        });
    },

    /**
     Cancels any outstanding automatic token refreshes.

     @method invalidate
     @return {Ember.RSVP.Promise} A resolving promise
     */
    invalidate: function() {
        Ember.run.cancel(this._refreshTokenTimeout);
        delete this._refreshTokenTimeout;
        return new Ember.RSVP.Promise(function(resolve) { resolve(); });
    },

    /**
     * Looks up the userId in the main app's store and sets the auth's +session.user+
     * variable (accessible throughout the app) to that user.
     *
     * @param userId
     * @private
     */
    _setUser: function(userId) {
        var mainStore = HubHub.__container__.lookup('store:main');
        mainStore.find('user', userId).then(function(user) {
            currentSession = HubHub.__container__.lookup('ember-simple-auth:session:current');
            currentSession.set('user', user);
            return user;
        });
    },

    /**
     @method scheduleAccessTokenRefresh
     @private
     */
    scheduleAccessTokenRefresh: function(expiry, refreshToken) {
        var _this = this;
        if (this.refreshAccessTokens) {
            Ember.run.cancel(this._refreshTokenTimeout);
            delete this._refreshTokenTimeout;
            var waitTime = (expiry || 0) * 1000 - 5000; //refresh token 5 seconds before it expires
            if (!Ember.isEmpty(refreshToken) && waitTime > 0) {
                this._refreshTokenTimeout = Ember.run.later(this, this.refreshAccessToken, expiry, refreshToken, waitTime);
            }
        }
    },

    /**
     @method refreshAccessToken
     @private
     */
    refreshAccessToken: function(expiry, refreshToken) {
        Ember.Logger.debug('MEOW: refreshing access token');
        var _this = this;
        var data  = { refresh_token: refreshToken };
        this.makeRequest(data).then(function(response) {
            Ember.run(function() {
                expiry       = response.expires_in || expiry;
                refreshToken = response.refresh_token || refreshToken;
                _this.scheduleAccessTokenRefresh(expiry, refreshToken);
                _this.trigger('ember-simple-auth:session-updated', Ember.$.extend(response, { expires_in: expiry, refresh_token: refreshToken }));
            });
        }, function(xhr, status, error) {
            Ember.Logger.warn('Access token could not be refreshed - server responded with ' + error + '.');
        });
    },

    /**
     @method makeRequest
     @private
     */
    makeRequest: function(data) {
        return Ember.$.ajax({
            url:         this.serverTokenEndpoint,
            type:        'POST',
            data:        JSON.stringify(data),
            dataType:    'json',
            contentType: 'application/json'
        });
    }
});


/**
 Authorizer that conforms to HubHub's method of authentication
 ([RFC 6749](http://tools.ietf.org/html/rfc6749)) by adding auth tokens
 ([RFC 6749](http://tools.ietf.org/html/rfc6750)).

 @class CustomAuthorizer
 @namespace HubHub
 @extends Ember.SimpleAuth.Authorizers.Base
 */
HubHub.CustomAuthorizer = Ember.SimpleAuth.Authorizers.Base.extend({
    /**
     Authorizes an XHR request by adding the `access_token` property from the
     session as an auth token in the `Authorization` header:

     ```
     Authorization: AUTH-TOKEN <token>
     ```

     @method authorize
     @param {jqXHR} jqXHR The XHR request to authorize (see http://api.jquery.com/jQuery.ajax/#jqXHR)
     @param {Object} requestOptions The options as provided to the `$.ajax` method (see http://api.jquery.com/jQuery.ajaxPrefilter/)
     */
    authorize: function(jqXHR, requestOptions) {
        if (!Ember.isEmpty(this.get('session.access_token'))) {
            jqXHR.setRequestHeader('Authorization', 'AUTH-TOKEN ' + this.get('session.access_token'));
        }
    }
});

