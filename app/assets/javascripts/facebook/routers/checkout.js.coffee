class App.Routers.Checkout extends Backbone.Router
  routes:
    "/shops/checkouts" : "checkout"
    "/shops/checkouts/success" : "success_order"
    "/shops/checkouts/cancel_order" : "cancel_order"
 
  initialize: ->
    @order = new App.Order
    @address = new App.Address
    @translate = new App.Translate

  checkout: ->
    self = @
    @carts = new App.Collections.Carts
    @translate.fetch
      success: () ->
        self.carts.fetch
          success: (collection, response) ->
            self.checkout = new App.Views.Checkout.Checkout({carts: collection, address: self.address, translate: self.translate})

  success_order: ->
    self = @
    @translate.fetch
      success: () ->
        new App.Views.Checkout.Success({translate: self.translate})

  cancel_order: ->
    self = @
    @translate.fetch
      success: () ->
        new App.Views.Checkout.CancelOrder({translate: self.translate})
