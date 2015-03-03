class App.Routers.Orders extends Backbone.Router
  routes:
    "/orders": "index"
    "/orders/:id": "show"

  initialize: ->
    @orders = new App.Collections.Orders()
    @translate = new App.Translate

  index: ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @translate.fetch
      success: ->
        self.orders.fetch
          success: (collection, response) ->
            @view = new App.Views.Orders.Index(orders: collection, translate: self.translate)
            $("#app").html(@view.render().el)
            App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  show: (id) ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @translate.fetch
      success: ->
        order = new App.Order({number: id})
        order.fetch
          success: (model, response) ->
            @showOrderView.close() if @showOrderView?
            @showOrderView = new App.Views.Orders.Show(order: order, translate: self.translate)
            App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'
