HubHub.FaqController = Ember.Controller.extend({
  actions:
    # http://stackoverflow.com/questions/18445661/ember-js-anchor-link
    jumpToEmailSubjectGuidelines: ->
      $("html, body").animate
        scrollTop: $("#email-subject-guidelines").offset().top
      , 1000
})

