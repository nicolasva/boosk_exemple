class App.OptionType extends Backbone.Model
  url: ->
    base = "/#{App.ui()}/shops/#{App.current_shop}/option_types"
    return base if @isNew()
    base + (if base.charAt(base.length - 1) is "/" then "" else "/") + @id

  validate: (attributes) ->
    "Error !" unless attributes
