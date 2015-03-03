class App.Collections.Orders extends Backbone.Collection
  model: App.Order

  url: ->
    "/#{App.ui()}/addresses/#{@address_id}/orders"
