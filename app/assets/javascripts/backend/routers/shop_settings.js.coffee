class App.Routers.ShopSettings extends Backbone.Router
  routes:
    "/settings/wizard=:value":    "generalSettings"
    "/settings/menu":             "editMenu"
    "/settings/customization":    "editCustomization"
    "/settings/option_types":     "indexOptionTypes"
    "/settings/shipping_methods": "indexShipping"
    "/settings/tax_rates":        "indexTaxRates"
    "/settings/zones":            "indexZones"
    "/settings/payment":          "editPayment"
    "/settings/status":           "editStatus"

  initialize: ->
    @taxonomies = new App.Collections.Taxonomies
    @option_types = new App.Collections.ProductOptionTypes
    @shipping_methods = new App.Collections.ShippingMethods
    @tax_rates = new App.Collections.TaxRates
    @zones = new App.Collections.Zones
    @devises = new App.Collections.Devises
    @geographic_regions = new App.Collections.GeographicRegions
    @account = new App.Account
    @translate = new App.Translate
    @shop_functionnality = new App.ShopFunctionnality
    @wizard = false

  generalSettings: (wizard)->
    App.eventsDispatcher.trigger 'startLoading'
    if wizard == "true" then @wizard = true else @wizard = false
    self = @
    @translate.fetch
      success: ->
        if self.wizard
          $("header.login a:not('.chzn-single,.logout,#new-shop')").bind 'click', (e) ->
            e.preventDefault()
            e.stopPropagation()
            new App.Views.Popup
              translate: self.translate.toJSON()
              message: self.translate.toJSON().views.shop_setting.chroot_in_wizard
              el: $('#modal .modal-body')
              mode: "confirm"
              callback: ->
                window.location.href = $(e.currentTarget).attr('href')
                $("header.login a:not('.chzn-single,.logout,#new-shop')").unbind('click')
        shop = new App.Shop(uuid: App.current_shop)
        shop.fetch
          success: (model, resp) ->
            if self.editShopView
              self.editShopView.close()
            self.devises.fetch
              success: (collection, data) ->
                self.editShopView = new App.Views.Shops.Edit(
                  model: model
                  translate: self.translate
                  wizard: self.wizard
                  devises: collection
                )
                App.eventsDispatcher.trigger 'loadingComplete'
              error: ->
                App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
            new App.Views.Notice(message: "Could not find that shop.", type: "error")
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  editMenu: ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @translate.fetch
      success: ->
        shop = new App.Shop(uuid: App.current_shop)
        shop.fetch
          success: ->
            self.taxonomies.fetch
              success: (collection, response) ->
                @view = new App.Views.ShopSettings.Menu(
                  model: collection.first()
                  translate: self.translate
                  shop: shop
                  wizard: self.wizard
                )
              error: ->
                App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  editCustomization: ->
    App.eventsDispatcher.trigger 'startLoading'
    shop = new App.Shop(uuid: App.current_shop)
    self = @
    @translate.fetch
      success: ->
        self.account.fetch
          success: ->
            shop.fetch
              success: (model, resp) ->
                customization = model.customization
                customization.fetch
                  success: (model, response) ->
                    if self.wizard and !self.account.get('plan').has_customization
                      window.location.hash = "/settings/payment"
                    else
                      if self.editCustomizationView
                        self.editCustomizationView.close()
                      model.forbidden = !self.account.get('plan').has_customization
                      self.editCustomizationView = new App.Views.Customizations.Edit
                        customization: model
                        translate: self.translate
                        shop: shop
                        wizard: self.wizard
                  error: ->
                    App.eventsDispatcher.trigger 'loadingComplete'
                    new App.Views.Notice(message: "Could not find that shop customization.", type: "error")
                    window.location.hash = "#"
              error: ->
                App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  indexOptionTypes: ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @translate.fetch
      success: ->
        shop = new App.Shop(uuid: App.current_shop)
        shop.fetch
          success: ->
            self.option_types.fetch
              success: (collection, response) ->
                @view = new App.Views.ProductOptionTypes.Index(
                  option_types: collection
                  translate: self.translate
                  shop: shop
                  wizard: self.wizard
                )
                $("#app").html(@view.render().el)
                $('#shop-preview').popover()
                App.eventsDispatcher.trigger 'loadingComplete'
              error: ->
                App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  indexShipping: ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @translate.fetch
      success: ->
        shop = new App.Shop(uuid: App.current_shop)
        shop.fetch
          success: ->
            self.shipping_methods.fetch
              success: (collection, response) ->
                @view = new App.Views.ShippingMethods.Index
                  collection: collection
                  translate: self.translate
                  shop: shop
                  wizard: self.wizard
                $("#app").html(@view.render().el)
                $('#shop-preview').popover()    
                App.eventsDispatcher.trigger 'loadingComplete'
              error: ->
                App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  indexTaxRates: ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @translate.fetch
      success: ->
        shop = new App.Shop(uuid: App.current_shop)
        shop.fetch
          success: ->
            self.zones.fetch
              success: (zones) ->
                self.tax_rates.fetch
                  success: (collection, response) ->
                    @view = new App.Views.TaxRates.Index(
                      collection: collection
                      zones: zones
                      translate: self.translate
                      shop: shop
                      wizard: self.wizard
                    )
                    $("#app").html(@view.render().el)
                    $('#shop-preview').popover()
                    App.eventsDispatcher.trigger 'loadingComplete'
                  error: ->
                    App.eventsDispatcher.trigger 'loadingComplete'
              error: ->
                App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  indexZones: ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @translate.fetch
      success: ->
        shop = new App.Shop(uuid: App.current_shop)
        shop.fetch
          success: ->
            self.zones.fetch
              success: (collection, response) ->
                @view = new App.Views.Zones.Index
                  collection: collection
                  translate: self.translate.toJSON()
                  shop: shop
                  wizard: self.wizard
                $("#app").html(@view.render().el)
                $('#shop-preview').popover()
    
                App.eventsDispatcher.trigger 'loadingComplete'
              error: ->
                App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  editPayment: ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @translate.fetch
      success: ->
        self.account.fetch
          success: ->
            shop = new App.Shop(uuid: App.current_shop)
            shop.fetch
              success: (model, resp) ->
                if self.editShopView
                  self.editShopView.close()
                self.editPaymentView = new App.Views.Payment.Edit(
                  model: model
                  translate: self.translate
                  wizard: self.wizard
                  account: self.account
                )
                App.eventsDispatcher.trigger 'loadingComplete'
              error: ->
                App.eventsDispatcher.trigger 'loadingComplete'
                new App.Views.Notice(message: "Could not find that shop.", type: "error")
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  editStatus: ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @translate.fetch
      success: ->
        self.shop_functionnality.fetch
          success: ->
            shop = new App.Shop(uuid: App.current_shop)
            shop.fetch
              success: (model, resp) ->
                customization = model.customization
                customization.fetch
                  success:  ->
                    if self.fbSettingsView
                      self.fbSettingsView.close()
                    self.fbSettingsView = new App.Views.ShopSettings.Status(
                      shop: model
                      customization: customization
                      translate: self.translate
                      wizard: self.wizard
                      shop_functionnality: self.shop_functionnality
                    )
                    App.eventsDispatcher.trigger 'loadingComplete'
                  error: ->
                    App.eventsDispatcher.trigger 'loadingComplete'
              error: ->
                App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
