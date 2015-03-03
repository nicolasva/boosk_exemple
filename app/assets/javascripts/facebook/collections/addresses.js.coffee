class App.Collections.Addresses extends Backbone.Collection
  model: App.Address

  url: ->
    "/#{App.ui()}/addresses"
