class App.Collections.Zones extends Backbone.Collection
  model: App.Zone

  bulk_destroy_url: ->
    "/shops/#{App.current_shop}/zones/destroy/all"

  url: ->
    base = "/shops/#{App.current_shop}/zones"

  alreadyExists: (name, id) ->
    @some (model) ->
      model.get('name') is name and model.id isnt id and not model.isNew()