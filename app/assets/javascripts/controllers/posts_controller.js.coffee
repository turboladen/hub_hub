HubHub.PostsController = Ember.ArrayController.extend
  currentPage: 1
  perPage: 25

  totalPages: ( ->
    @store.metadataFor('post').total_pages
  ).property()

  totalCount: ( ->
    @store.metadataFor('post').total_count
  ).property()

  actions:
    nextPage: ->
      @incrementProperty('currentPage')
      newList = @store.find 'post',
        page: @currentPage,
        per_page: @perPage
      @set('content', newList)
