class App.Shop extends Backbone.Model

 initialize: ->
    @id = @attributes['uuid']

  url: ->
    base = "/#{App.ui()}/shops/#{@id}"

  validate: (attributes) ->
    "Error!" unless attributes
