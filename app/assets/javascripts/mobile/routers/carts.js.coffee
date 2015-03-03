class App.Routers.Carts extends Backbone.Router
  routes:
    "/carts/edit": "edit"

  initialize: ->
    @translate = new App.Translate()
    @carts = new App.Collections.Carts()
    @carts.fetch
      success: (collection, response) ->
        @viewnumberproduct = new App.Views.CartItems.NumberProduct(carts: collection)

  edit: ->
    self = @
    @translate.fetch
      success: () ->
        self.carts.fetch
          success: (collection, response) ->
            @vieweditcartitems = new App.Views.Cart.Edit(carts: collection, translate: self.translate)
