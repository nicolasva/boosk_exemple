class App.Routers.Promotions extends Backbone.Router
  routes:
    "/promotions": "indexPromotions"

  initialize: ->
    @promotions = new App.Collections.Promotions()

  indexPromotions: ->
    App.eventsDispatcher.trigger 'startLoading'
    @promotions.fetch
      success: (collection) ->
        @view = new App.Views.Promotions.Index(collection: collection, translate: App.i18n())
        $("#app").html(@view.render().el)
        App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'
