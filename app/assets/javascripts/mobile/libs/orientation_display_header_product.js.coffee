$(window).bind 'orientationchange resize', ->
  orientation = window.orientation
  regex = new RegExp(".{1,}products\/.{1,}$")
  window_location_hash = window.location.hash
  if orientation == 0
    if regex.test(window_location_hash)
      $("#header").hide()
    else
      $("#header").show()
  else
    $("#header").hide()

