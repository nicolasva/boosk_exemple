class App.Views.Orders.Index extends Backbone.View
  template: JST["facebook/templates/orders/index"]

  total: ->
    price = 0
    $.each(@options.orders.toJSON(), (key_orders, val_orders) ->
      $.each(val.line_items, (key_line_items, val_line_items) ->
        price += val['price']
      ) 
    )
    return price
      
  render: ->
    $(@el).html(Haml.render(@template(), { locals: { orders: @options.orders.toJSON(),  total_orders_price: @total()} }))

  

