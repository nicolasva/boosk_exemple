(->
  Backbone.History::loadUrl = (fragmentOverride) ->
    fragment = @fragment = @getFragment(fragmentOverride)
    matched = _.any(@handlers, (handler) ->
      if handler.route.test(fragment)
        handler.callback fragment
        true
    )
    fragment = "/" + fragment  unless /^\//.test(fragment)
    window._gaq.push ["_trackPageview", fragment]  if window._gaq isnt `undefined`
    matched
).call this
