module "EmberJS Application Template",
  teardown: ->
    HubHub.reset()

test "default template", ->
  visit("/").then ->
    ok find("*"), "Found Some HTML"
