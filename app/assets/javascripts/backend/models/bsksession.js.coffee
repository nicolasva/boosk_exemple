class App.Bsksession extends Backbone.Model
  url: ->
    return "/bsksession"

  validate: (attributes) ->
    "Error!" unless attributes
