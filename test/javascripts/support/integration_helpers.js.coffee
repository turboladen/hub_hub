
# a litte helper for finding elements
(exports ? this).exists = (selector) ->
  return !!find(selector).length
