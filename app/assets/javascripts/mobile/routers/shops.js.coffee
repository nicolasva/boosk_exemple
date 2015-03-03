class App.Routers.Shops extends Backbone.Router
  routes:
    "/shops/:id": "show"

  initialize: ->
    @translate = new App.Translate()
    @taxonomies = new App.Collections.Taxonomies()

  show: (id) ->
    self = @
    App.current_shop = id
    shop = new App.Shop(uuid: App.current_shop)
    @translate.fetch
      success: () ->
        self.taxonomies.fetch
          success: (collection, response) ->
            new App.Views.Taxonomies.Index(taxonomies: collection.first(), translate: self.translate)
            shop.fetch
              success: (model, response) ->
                new App.Views.Shops.Show({shop: model, translate: self.translate})
