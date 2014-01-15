# For more information see: http://emberjs.com/guides/routing/

HubHub.Router.map ()->
  enableLogging: true
  @route 'home'

  @resource 'posts'
  @resource 'post',
    path: 'posts/:post_id'

  @resource 'spokes', ->
    @resource 'spoke',
      path: '/:spoke_id'

  @route 'sign-in'
  @route 'registration'
  @route 'tos'
  @route 'faq'

