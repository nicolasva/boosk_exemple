class App.ShippingMethod extends Backbone.Model
  defaults:
    name: ""
    match_all: false
    match_one: false
    match_none: false

  initialize: (attributes) ->
    if attributes && attributes.zone
      @zone = new App.Zone attributes.zone
    else
      @zone = new App.Zone

  url: ->
    base = "/shops/#{App.current_shop}/shipping_methods"
    return base  if @isNew()
    base + (if base.charAt(base.length - 1) is "/" then "" else "/") + @id

  validate: (attributes) ->
    "Error!" unless attributes
