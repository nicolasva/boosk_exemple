class App.Views.Cart.Index extends Backbone.View
  el: '#shopping_cart' 
  template: JST["facebook/templates/cart/index"]

  initialize: (options) ->
    @cart = @options.cart
    @render()

  render: ->
    unless @cart.toJSON()[0] == undefined
      $(@el).html(Haml.render(@template(), { locals: {
        cart: @cart.toJSON(),
        shop_id: App.current_shop,
        total: App.total_cart(@cart.models)}
      }))
    
