HubHub.ResponseController = Ember.ObjectController.extend
  createdAtAgo: (->
    moment(@get('createdAt')).fromNow()
  ).property('createdAt')
