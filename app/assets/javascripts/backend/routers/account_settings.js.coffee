class App.Routers.AccountSettings extends Backbone.Router
  routes:
    "/accounts": "general_settings"
    "/accounts/plans": "plans_settings"
    "/accounts/administrators": "administrators_settings"
    "/accounts/shops": "shops_settings"
    "/accounts/receipts": "receipts_settings"

  initialize: ->
    @translate = new App.Translate
    @account = new App.Account
    @shops = new App.Collections.Shops
    @plans = new App.Collections.Plans
    @zones = new App.Collections.Zones
    @administrators = new App.Collections.Administrators

  general_settings: ->
    App.eventsDispatcher.trigger 'startLoading'
    @zones.fetch
      success: (collections, response) ->
        new App.Views.Accounts.Edit(zones: collections)
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  administrators_settings: ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @translate.fetch
      success: ->
        self.account.fetch
          success: ->
            self.administrators.fetch
              success: ->
                App.eventsDispatcher.trigger 'loadingComplete'    
                new App.Views.Administrators.Index
                  administrators: self.administrators
                  translate: self.translate
                  account: self.account
              error: (collections, xhr)->
                switch xhr.status
                  when 403
                    new App.Views.Administrators.Index
                      administrators: self.administrators
                      translate: self.translate
                      forbidden: true
                App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'  
  
  plans_settings: ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @translate.fetch
      success: ->
        self.account.fetch
          success: ->
            self.plans.fetch
              success: ->
                new App.Views.Plans.Edit
                  translate: self.translate
                  account: self.account
                  plans: self.plans
                App.eventsDispatcher.trigger 'loadingComplete'
              error: ->
                App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  shops_settings: ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @translate.fetch
      success: ->
        self.shops.fetch
          success: ->
            new App.Views.Shops.Index
              translate: self.translate
              shops: self.shops
              App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  receipts_settings: ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @translate.fetch
      success: ->
        new App.Views.Receipts.Index
          translate: self.translate
        App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'