HubHub.Router.map ->
  @route 'home'

  @resource 'posts'
  @resource 'post',
    path: 'posts/:post_id'

  @resource 'spokes', ->
    @resource 'spoke',
      path: '/:spoke_id'

  @route 'login'
  @route 'sign-out'
  @route 'registration'
  @route 'tos'
  @route 'faq'
