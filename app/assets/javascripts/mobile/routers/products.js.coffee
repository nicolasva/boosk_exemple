class App.Routers.Products extends Backbone.Router
  routes: 
    "/products/:uuid": "show"

  initialize: ->
    @translate = new App.Translate()
    @option_types = new App.Collections.OptionTypes()
    @shop = new App.Shop(uuid: App.current_shop)

  show: (uuid) ->
    self = @
    product = new App.Product(id: uuid)
    self.translate.fetch
      success: ->
        product.fetch
          success: ->
            self.option_types.fetch
              success: ->
                self.shop.fetch
                  success: ->
                    new App.Views.Products.Show
                      product: product
                      shop: self.shop
                      option_types: self.option_types
                      translate: self.translate
