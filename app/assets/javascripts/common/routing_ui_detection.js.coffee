$(document).ready ->
  if App.ui() is 'facebook' && parent.location == window.location
    shop = new App.Shop(uuid: App.current_shop)
    shop.fetch
      success: (model, response) ->
        window.location.href =  model.attributes.uri_facebook
