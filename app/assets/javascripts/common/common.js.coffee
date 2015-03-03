#= require ./form_validate
#= require ./rescuejs

$(document).ready ->
  $("body").tooltip selector: "[rel=tooltip]"

String.prototype.truncate = (length) ->
  if @length > length
    return @.substring(0, length-3) + "..."
  else
    return @