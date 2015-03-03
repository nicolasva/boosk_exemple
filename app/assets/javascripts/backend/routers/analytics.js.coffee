class App.Routers.Analytics extends Backbone.Router
  routes:
    "/analytics": "index"

  initialize: ->
    @shops = new App.Collections.Shops
    @analytics = new App.Analytic
    @translate = new App.Translate
    @products = new App.Collections.Products
    @taxonomies = new App.Collections.Taxonomies

  index: ->
    App.eventsDispatcher.trigger 'startLoading'
    @current_shop = App.current_shop
    self = @
    @analytics.from = @analytics.to = @analytics.taxon_filter = null
    @analytics.fetch
      success: ->
        self.translate.fetch
          success: ->
            self.shops.fetch
              success: ->
                self.products.fetch
                  success: ->
                    self.taxonomies.fetch
                      success: ->
                        new App.Views.Analytics.Index
                          analytics: self.analytics
                          shop: self.shops.get(self.current_shop)
                          translate: self.translate
                          products: self.products
                          taxonomies: self.taxonomies
                        App.eventsDispatcher.trigger 'loadingComplete'
                      error: ->
                        App.eventsDispatcher.trigger 'loadingComplete'
                  error: ->
                    App.eventsDispatcher.trigger 'loadingComplete'
              error: ->
                App.eventsDispatcher.trigger 'loadingComplete'
      error: (model, xhr) ->
        switch xhr.status
          when 403
            self.translate.fetch
              success: ->
                self.shops.fetch
                  success: ->
                    self.products.fetch
                      success: ->
                        self.taxonomies.fetch
                          success: ->
                            new App.Views.Analytics.Index
                              analytics: new App.Analytic({fake: true})
                              shop: self.shops.get(self.current_shop)
                              translate: self.translate
                              products: self.products
                              taxonomies: self.taxonomies
                            App.eventsDispatcher.trigger 'loadingComplete'
                          error: ->
                            App.eventsDispatcher.trigger 'loadingComplete'
                      error: ->
                        App.eventsDispatcher.trigger 'loadingComplete'
                  error: ->
                    App.eventsDispatcher.trigger 'loadingComplete'
