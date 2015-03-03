class App.Views.CartItems.CartUpdatePriceToTable extends Backbone.View
  initialize: (options) ->
    @cartitem = options.cartitem
    @el = options.el
    @render()

  render: ->
    price = parseInt(@cartitem.toJSON().product.price)
    quantity = parseInt(@cartitem.toJSON().quantity)
    total_price_product = price * quantity
    @el.html(App.FixedPrice(total_price_product))

