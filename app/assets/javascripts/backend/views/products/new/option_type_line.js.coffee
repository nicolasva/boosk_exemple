App.Views.Products ||= {}
App.Views.Products.New ||= {}

class App.Views.Products.OptionTypeLine extends Backbone.View
  template: JST["backend/templates/products/option_type_line"]
  tagName: "tr"

  initialize: (options) ->
    @option_type = options.option_type
    @render()


  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      option_type: @option_type.toJSON()
    } }))
    return @
