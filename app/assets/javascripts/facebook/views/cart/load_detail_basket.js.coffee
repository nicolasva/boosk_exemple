class App.Views.Cart.LoadDetailBasket extends Backbone.View
  template: JST["facebook/templates/cart/load_detail_basket"]

  initialize: (options) ->
    @cart = options.cart
    @el = "#item_" + options.cart.id
    @render()

  render: ->
    $(@el).html(Haml.render(@template(), { locals: { item: @cart.toJSON() }}))
