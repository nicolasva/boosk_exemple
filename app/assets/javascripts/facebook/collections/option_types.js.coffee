class App.Collections.OptionTypes extends Backbone.Collection
  model: App.OptionType

  # hard integer in url !?
  url: ->
    "/#{App.ui()}/shops/#{App.current_shop}/option_types"
