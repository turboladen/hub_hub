#= require jquery
#= require jquery_ujs
#= require handlebars
#= require ember
#= require ember-data
#= require twitter/bootstrap
#= require_self
#= require hub_hub

# for more details see: http://emberjs.com/guides/application/
window.HubHub = Ember.Application.create({
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
