App.tracker = (obj) ->
  if _.isElement @
    action = $(@).attr('data-action')
    object = $(@).attr('data-object')
    ref = $(@).attr('data-ref')
  else
    action = obj.action
    object = obj.object
    ref = obj.ref
   $.ajax
     type: "POST"
     url: "/trackers"
     data: { actions: action, object: object, ref: ref }
