App.Views.ProductOptionTypes ||= {}

class App.Views.ProductOptionTypes.RowTable extends Backbone.View
  template: JST["backend/templates/product_option_types/row_table"]
  tagName: "tr"

  initialize: (options) ->
    this.render().el

  render: ->
    $(@el).html(Haml.render(@template(), { locals: { option_type: @options.option_type.toJSON()} }))
    $(@el).attr "data-id", @options.option_type.id
    return this
