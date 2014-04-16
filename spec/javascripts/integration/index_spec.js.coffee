module "Home Page",
  setup: -> ({})

  teardown: ->
    HubHub.reset()

test "it shows the spokes", ->
  expect(10)

  visit('/').then ->
    ok find('a[href*="/spokes/1"]'), "Spoke 1 was rendered."
    ok find('a[href*="/spokes/2"]'), "Spoke 2 was rendered."
    ok find('a[href*="/spokes/3"]'), "Spoke 3 was rendered."
    ok find('a[href*="/spokes/4"]'), "Spoke 4 was rendered."
    ok find('a[href*="/spokes/5"]'), "Spoke 5 was rendered."
    ok find('a[href*="/spokes/6"]'), "Spoke 6 was rendered."
    ok find('a[href*="/spokes/7"]'), "Spoke 7 was rendered."
    ok find('a[href*="/spokes/8"]'), "Spoke 8 was rendered."
    ok find('a[href*="/spokes/9"]'), "Spoke 9 was rendered."
    ok find('a[href*="/spokes/10"]'), "Spoke 10 was rendered."
