class App.Views.Cart.UpdateTotalPriceAllProductToTable extends Backbone.View
  el: "#value_total"
  
  initialize: (options) ->
    @render()   

  render: ->
    $(@el).html(@get_price_total_product())

  get_price_total_product: ->
    price = 0 
    $(".tr_value_order").each (index) ->
      price +=  parseFloat($(this).html())
    return App.FixedPrice(price)
