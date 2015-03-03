class App.Routers.Checkout extends Backbone.Router
  routes:
    "/shops/checkouts" : "new_step_1"
    "/shops/checkouts/step2" : "new_step_2"

  initialize: ->
    @translate = new App.Translate()
    @carts = new App.Collections.Carts()
    @geographic_regions = new App.Collections.GeographicRegions
    @contact = new App.Contact

  new_step_1: ->
    self = @
    @translate.fetch
      success: ->
        self.carts.fetch
          success: ->
            self.geographic_regions.fetch
              success: (collection, response) ->
                @ViewCheckoutsNewStep1 = new App.Views.Checkouts.New.Step1
                  geographic_regions: collection
                  contact: self.contact
                  translate: self.translate
                  carts: self.carts

  new_step_2: ->
    self = @
    @translate.fetch
      success: () ->
        self.carts.fetch
          success: (collection, response) ->
            @ViewCheckoutNewStep2 = new App.Views.Checkouts.New.Step2({carts: collection, contact: self.contact, translate: self.translate})

