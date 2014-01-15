HubHub.ApplicationRoute = Ember.Route.extend
  model: ->
    @store.find('spoke')

  setupController: (controller, model)->
    @controllerFor('spokes').set('model', model)

  renderTemplate: (controller, model)->
    @render()

    @render 'spokes',
      into: 'application',
      outlet: 'spokes'
