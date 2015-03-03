class App.Views.CartItems.NumberProduct extends Backbone.View
  el: "#basket_shop"
  template: JST["mobile/templates/cart/cart_number_update_menu"]

  initialize: (options) ->
    @carts = options.carts
    @render()

  render: ->
    $(@el).html(Haml.render(@template(), {locals: {product_number: @carts.length}})) 
