#= require jquery
#= require jquery_ujs
#= require handlebars
#= require ember
#= require ember-data
#= require ember-auth
#= require ember-auth-module-ember-data
#= require ember-auth-module-rememberable
#= require ember-auth-request-jquery
#= require ember-auth-response-json
#= require ember-auth-strategy-token
#= require ember-auth-session-cookie
#= require twitter/bootstrap
#= require_self
#= require hub_hub

# for more details see: http://emberjs.com/guides/application/
window.HubHub = Ember.Application.create({
  LOG_ACTIVE_GENERATION: true,
  LOG_TRANSITIONS: true,
  LOG_BINDINGS: true,
  LOG_VIEW_LOOKUPS: true,
  LOG_STACKTRACE_ON_DEPRECATION: true,
  LOG_VERSION: true,
  debugMode: true
})

# To be able to do <a data-toggle="something">
Ember.LinkView.reopen
  attributeBindings: ['data-toggle']

# Logger shortcut
window.log = Em.Logger
