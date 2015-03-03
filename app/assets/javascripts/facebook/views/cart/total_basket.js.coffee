class App.Views.Cart.TotalBasket extends Backbone.View
  el: '#total_basket' 
  template: JST["facebook/templates/cart/total_basket"]

  initialize: (options) ->
    @cartitems = new App.Collections.CartItems()
    @render()

  render: ->
    el = @el
    template = @template
    @cartitems.fetch 
      success: (collections, response) ->
        $(el).html(Haml.render(template(), { locals: {total: App.total_cart(collections.models) }})) 
    
