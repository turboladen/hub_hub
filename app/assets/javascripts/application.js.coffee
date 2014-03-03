#= require jquery
#= require jquery_ujs
#= require handlebars
#= require ember
#= require ember-data
#= require ember-simple-auth
#= require bootstrap
#= require moment
#= require_self

# Ember.FEATURES["query-params"] = true

# for more details see: http://emberjs.com/guides/application/
window.HubHub = Ember.Application.create({
  LOG_ACTIVE_GENERATION: true,
  LOG_BINDINGS: true,
  LOG_CUSTOM: true,
  LOG_MODULE_RESOLVER: true,
  LOG_QUERIES: true,
  LOG_STACKTRACE_ON_DEPRECATION: true,
  LOG_TRANSITIONS: true,
  LOG_TRANSITIONS_INTERNAL: true,
  LOG_VERSION: true,
  LOG_VIEW_LOOKUPS: true,

  #RAISE_ON_DEPRECATION: true,
  debugMode: true,

  # Deprecation or API change configs
  #HELPER_PARAM_LOOKUPS: true,
})

# To be able to do <a data-toggle="something">
Ember.LinkView.reopen
  attributeBindings: ['data-toggle']

# Logger shortcut
window.log = Em.Logger
