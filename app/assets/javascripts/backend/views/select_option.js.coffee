App.Views ||= {}

class App.Views.SelectOption extends Backbone.View
  tagName: "option"

  initialize: (options) ->
    _.bindAll @, "render"
    @render()

  render: () ->
    $(@el).html @options.label
    $(@el).attr "value", @options.value
    $(@el).attr("selected", "selected") if @options.selected
    return this