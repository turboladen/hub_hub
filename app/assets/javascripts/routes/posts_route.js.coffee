HubHub.PostsRoute = Ember.Route.extend
  model: ->
    nextPage = @controllerFor('posts').get('currentPage')
    perPage = @controllerFor('posts').get('perPage')

    @store.find 'post',
      page: nextPage,
      per_page: perPage

  renderTemplate: (controller, model)->
    @render 'posts',
      into: 'application',
      outlet: 'posts'
