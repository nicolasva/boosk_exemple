class App.Routers.Wizards extends Backbone.Router
  routes:
    "/w_step1":  "w_step1"
    "/w_step2":  "w_step2"
    "/w_step3":  "w_step3"

  initialize: ->
    @shop = new App.Shop
    @account = new App.Account
    @devises = new App.Collections.Devises
    @geographic_regions = new App.Collections.GeographicRegions
    @translate = new App.Translate

  w_step1: ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @navigate('wizard-shop')
    @translate.fetch
      success: ->
        self.account.fetch
          success: ->
            self.geographic_regions.fetch
              success: ->
                unless self.devises.length > 0
                  self.devises.fetch
                    success: (collection, data) ->
                      @view = new App.Views.Wizards.Step1(shop: self.shop, account: self.account, devises: collection, geographic_regions: self.geographic_regions, translate: self.translate)
                      $("#app").html(@view.render().el)
                      App.eventsDispatcher.trigger 'loadingComplete'
                    error: ->
                      App.eventsDispatcher.trigger 'loadingComplete'
                else
                  @view = new App.Views.Wizards.Step1(shop: self.shop, devises: self.devises, translate: self.translate, geographic_regions: self.geographic_regions, account: self.account)
                  $("#app").html(@view.render().el)
                  App.eventsDispatcher.trigger 'loadingComplete'
              error: ->
                App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  w_step2: ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @translate.fetch
      success: ->
        self.account.fetch
          success: ->
            @view = new App.Views.Wizards.Step2
              shop: self.shop
              account: self.account
              translate: self.translate
            $("#app").html(@view.render().el)
            if $('.input-append').length > 1
              emails = $('.input-append')
              emails.splice(0, 1)
              for email in emails
                $(email).find('button').removeClass('add-email')
                $(email).find('button').addClass('del-email')
                $(email).find('button').html('x')
            App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  w_step3: ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @translate.fetch
      success: ->
        @view = new App.Views.Wizards.Step3
          shop: self.shop
          account: self.account
          translate: self.translate
        $("#app").html(@view.render().el)
        App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'