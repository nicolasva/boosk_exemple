class App.ProductVariant extends Backbone.Model
  url: ->
    base = "/mobile/shops/"+App.current_shop+"/products/"+@product_id+"/product_variants"
    return base if @isNew()
    base + (if base.charAt(base.length - 1) is "/" then "" else "/") + @id

  validate: (attributes) ->
    "Error!" unless attributes
