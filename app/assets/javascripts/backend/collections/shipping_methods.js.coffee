class App.Collections.ShippingMethods extends Backbone.Collection
  model: App.ShippingMethod

  bulk_destroy_url: ->
    "/shops/#{App.current_shop}/shipping_methods/destroy/all"

  url: ->
    base = "/shops/#{App.current_shop}/shipping_methods"
