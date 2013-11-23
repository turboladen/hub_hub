#= require jquery
#= require jquery_ujs
#= require handlebars
#= require ember
#= require ember-data
#= require_self
#= require turbolinks
#= require twitter/bootstrap
#= require hub_hub

# for more details see: http://emberjs.com/guides/application/
window.HubHub = Ember.Application.create({
  LOG_TRANSITIONS: true,
  debugMode: true
})
