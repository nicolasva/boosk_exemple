class App.Routers.Shops extends Backbone.Router

  routes:
    "/shops/:id": "show"

  initialize: ->
    @translate = new App.Translate
    @start = true

  show: (id) ->
    App.current_shop = id
    @shop = new App.Shop(uuid: App.current_shop)
    self = @
    @translate.fetch
      success: () ->
        self.shop.fetch
          success: (model, response) ->
            obj=
              action: "view"
              object: "shop"
              ref: self.shop.attributes.uuid
            App.tracker(obj) if self.start and App.preview isnt true
            self.start = false
            new App.Views.Shops.Show({shop: model, translate: self.translate})
