class App.Routers.Plans extends Backbone.Router
  routes:
    "/choose": "index"

  initialize: ->
    @plans = new App.Collections.Plans
    @account = new App.Account
    @translate = new App.Translate

  index: ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @navigate('plans')
    @translate.fetch
      success: ->
        self.plans.fetch
          success: ->
            self.account.fetch
              success: ->
                @view = new App.Views.Plans.Index
                  plans: self.plans
                  translate: self.translate
                  account: self.account
                App.eventsDispatcher.trigger 'loadingComplete'
              error: ->
                App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'
