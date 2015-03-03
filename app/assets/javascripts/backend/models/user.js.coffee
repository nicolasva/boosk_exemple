class App.User extends Backbone.Model
  url: ->
    return "/shops/#{@shop_id}/orders/checkout"

  validate: (attributes) ->
    "Error!" unless attributes
