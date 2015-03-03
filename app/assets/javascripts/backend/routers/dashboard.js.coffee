class App.Routers.Dashboard extends Backbone.Router
  routes:
    "/dashboard": "index"

  initialize: ->
    @shops = new App.Collections.Shops()
    @translate = new App.Translate
    @shop_functionnality = new App.ShopFunctionnality
    @analytics = new App.DashboardAnalytic

  index: ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @current_shop = App.current_shop
    @shops.fetch
      success: (collection, response) ->
        new App.Views.Listshop(shops: collection, current_shop: self.current_shop)
        self.translate.fetch
          success: ->
            self.analytics.fetch
              success: ->
                self.shop_functionnality.fetch
                  success: ->
                    new App.Views.Dashboard.Index
                      analytics: self.analytics
                      shop: self.shops.get(self.current_shop)
                      translate:self.translate
                      shop_functionnality: self.shop_functionnality
                    App.eventsDispatcher.trigger 'loadingComplete'
                  error: ->
                    App.eventsDispatcher.trigger 'loadingComplete'
              error: ->
                App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'
