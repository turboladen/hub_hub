# For more information see: http://emberjs.com/guides/routing/

HubHub.Router.map ()->
  @resource 'spokes', ->
    @resource 'spoke',
      path: '/:spoke_id'
  @route 'tos'
  @route 'faq'

