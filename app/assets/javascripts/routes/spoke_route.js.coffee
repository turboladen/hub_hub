HubHub.SpokeRoute = Ember.Route.extend
  model: (params)->
    @store.find('spoke', params.spoke_id)

  setupController: (controller, model)->
    @controllerFor('spoke').set('model', model)
    @controllerFor('posts').set('model', model.get('posts'))

  renderTemplate: (controller, model)->
    @render 'spoke',
      into: 'application',
      outlet: 'spoke'

    @render 'posts',
      into: 'application',
      outlet: 'posts'
