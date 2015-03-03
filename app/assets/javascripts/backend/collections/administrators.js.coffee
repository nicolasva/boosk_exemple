class App.Collections.Administrators extends Backbone.Collection
  model: App.Administrator

  url: '/administrators'

  bulk_destroy_url: ->
    "/administrators/destroy/all"
