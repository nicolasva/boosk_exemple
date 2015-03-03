class App.Collections.Dashboards extends Backbone.Collection
  model: App.Dashboard

  url: ->
    "/dashboard"
