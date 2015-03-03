class App.ShippingCategory extends Backbone.Model
  defaults:
    name: ""

  url: ->
    base = "/shops/#{App.current_shop}/shipping_categories"
    return base  if @isNew()
    base + (if base.charAt(base.length - 1) is "/" then "" else "/") + @id

  validate: (attributes) ->
    "Error!" unless attributes
