class App.Cart extends Backbone.Model
  url: ->
    base = "/#{App.ui()}/shops/#{App.current_shop}"
    return base + (if base.charAt(base.length - 1) is "/" then "" else "/") + @page

  validate: (attributes) ->
    "Error!" unless attributes
