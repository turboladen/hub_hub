# For more information see: http://emberjs.com/guides/routing/

HubHub.Router.map ()->
  @resource 'spokes'

  @resource 'spoke',
    path: '/spokes/:spoke_id', ->
      @resource 'posts'

      @resource 'post',
        path: 'posts/:post_id'

  @route 'sign-in'
  @route 'registration'
  @route 'tos'
  @route 'faq'

