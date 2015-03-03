((d) ->
  js = undefined
  id = "rescuejs"
  ref = d.getElementsByTagName("script")[0]
  return  if d.getElementById(id)
  js = d.createElement("script")
  js.id = id
  js.async = true
  js.src = "//rescuejs.com/rescue.beta.js?key=9c8d74a0-3321-4083-832d-bbfdb81eeb6d"
  ref.parentNode.insertBefore js, ref
) document

window.rescuejs =
  token: "9c8d74a0-3321-4083-832d-bbfdb81eeb6d"
  loaded: new Date().getTime()
