HubHub.PostController = Ember.ObjectController.extend
  createdAtAgo: (->
    moment(@get('createdAt')).fromNow()
  ).property('createdAt')
