class App.Views.Products.ProductsToOrder extends Backbone.View
  template: JST["mobile/templates/products/products_to_order"]

  initialize: (options) ->
    @product = options.product
    @el = $("#"+options.el)
    @render()

  render: -> 
    @el.children().first().html(Haml.render(@template(), {locals: {product: @product.toJSON()}}))
