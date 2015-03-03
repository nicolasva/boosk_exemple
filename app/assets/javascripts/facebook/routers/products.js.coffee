class App.Routers.Products extends Backbone.Router
  routes:
    "/products/:id": "show"

  initialize: ->
    @translate = new App.Translate
    @option_types = new App.Collections.OptionTypes
    @shop = new App.Shop(uuid: App.getCookie('front_shop_id'))

  show:  (uuid) ->
    self = @
    product = new App.Product(id: uuid)
    @translate.fetch
      success: ->
        product.fetch
          success: ->
            self.option_types.fetch
              success: ->
                self.shop.fetch
                  success: ->
                    self.view = new App.Views.Products.Show(
                      product: product
                      shop: self.shop
                      option_types: self.option_types
                      translate: self.translate
                    )
