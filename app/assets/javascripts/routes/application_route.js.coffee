HubHub.ApplicationRoute = Ember.Route.extend Ember.SimpleAuth.ApplicationRouteMixin,
  model: ->
    @store.find('spoke')

  setupController: (controller, model)->
    @controllerFor('spokes').set('model', model)

  renderTemplate: (controller, model)->
    @render()

    @render 'spokes',
      into: 'application',
      outlet: 'spokes'
