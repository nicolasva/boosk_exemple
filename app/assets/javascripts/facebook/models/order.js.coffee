class App.Order extends Backbone.Model
  url: ->
    base = "/#{App.ui()}/new_order" 

  validate: (attributes) ->
    "Error!" unless attributes
