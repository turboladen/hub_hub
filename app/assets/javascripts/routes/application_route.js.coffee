HubHub.ApplicationRoute = Ember.Route.extend SimpleAuth.ApplicationRouteMixin,
  model: ->
    @store.find('spoke')

  setupController: (controller, model)->
    @controllerFor('spokes').set('model', model)

  renderTemplate: (controller, model)->
    @render()

    @render 'spokes',
      into: 'application',
      outlet: 'spokes'
