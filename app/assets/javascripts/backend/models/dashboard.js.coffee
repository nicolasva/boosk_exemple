class App.Dashboard extends Backbone.Model
  url: ->
    return "/dashboard"

  validate: (attributes) ->
    "Error!" unless attributes
