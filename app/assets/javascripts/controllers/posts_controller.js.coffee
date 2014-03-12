HubHub.PostsController = Ember.ArrayController.extend
  currentPage: 1
  perPage: 25

  isFirstPage: (->
    @currentPage == 1
  ).property('currentPage')

  isLastPage: (->
    @currentPage == @get('totalPages')
  ).property('currentPage', 'totalPages')

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

    previousPage: ->
      @decrementProperty('currentPage')
      newList = @store.find 'post',
        page: @currentPage,
        per_page: @perPage
      @set('content', newList)
