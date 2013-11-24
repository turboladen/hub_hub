# For more information see: http://emberjs.com/guides/routing/

HubHub.SpokeRoute = Ember.Route.extend({
  model: (params)->
    @store.find('spoke', params.spoke_id)
})
