$(document).ready ->
  @customization = {}
  $("#edit_shop_customization").submit (e) ->

  

changeCustomizationAttribute = (event) ->
  target = event.target
  customization[target.name] = target.value

