class App.ProductVariantPicture extends Backbone.Model
  url: ->
    base = "/#{App.ui()}/shops/"+App.current_shop+"/products/#{@product_id}/product_variants/#{@product_variant_id}/product_variant_pictures"
    return base if @isNew()
    base + (if base.charAt(base.length - 1) is "/" then "" else "/") + @id

  validate: (attributes) ->
    "Error!" unless attributes
