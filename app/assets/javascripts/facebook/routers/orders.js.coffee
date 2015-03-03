class App.Routers.Orders extends Backbone.Router
  routes: 
    "/products/:product_id/orders": "create"

  initialize: -> 
    @order = new App.Order()

  create: (product_id) ->
    @order.product_id = product_id
    @order.save() 
    window.location.hash = "#/products/"+product_id
