class App.Collections.ProductOptionTypes extends Backbone.Collection
  model: App.ProductOptionType

  bulk_destroy_url: ->
    "/shops/#{App.current_shop}/option_types/destroy/all"

  url: ->
    base = "/shops/#{App.current_shop}/option_types"


  key_exist: (type, model) ->
    for option_type in @.toArray()
      return true if option_type.get('type') == type and model.id != option_type.id
    return false