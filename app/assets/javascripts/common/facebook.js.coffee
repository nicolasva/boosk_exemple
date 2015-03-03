App.checkFBPermissions = (event, extra) ->
  event.stopPropagation()
  event.preventDefault()
  FB.login (response) ->
    if response.authResponse
      return true
    else
      return false
  ,
    scope: "user_about_me,email,publish_actions" + ((if extra is "undefined" then "," + extra else ""))
  return
