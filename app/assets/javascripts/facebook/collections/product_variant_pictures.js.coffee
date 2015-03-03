class App.Collections.ProductVariantPictures extends Backbone.Collection
  model: App.ProductVariantPicture

  url: ->
    "/#{App.ui()}/shops/#{App.current_shop}/products/#{@product_id}/product_variants/#{@product_variant_id}/product_variant_pictures"

