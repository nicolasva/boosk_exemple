class App.Routers.ProductVariants extends Backbone.Router
  routes: 
    "/products/:product_id/product_variants/:id": "show"

  initialize: ->
    @productVariant = new App.ProductVariant()

  show: (product_id, id) ->
    @productVariant.product_id = product_id
    @productVariant.id = id
    @productVariant.fetch
      success: (model, response) ->
        @showProductVariantView = new App.Views.ProductVariants.ShowDetailProductVariants({productVariant: model})   
