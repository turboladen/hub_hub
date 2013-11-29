module "EmberJS Application Template",
  setup: ->
    HubHub.reset()

  teardown: ->
    HubHub.reset()

test "default template", ->
  visit("/").then ->
    ok exists("*"), "Found Some HTML"
