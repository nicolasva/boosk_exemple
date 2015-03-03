App.Views.Products ||= {}
class App.Views.Products.ProductOption extends Backbone.View
  template: JST["backend/templates/products/select_option_type"]

  render: ->
    option_type = @model.toJSON()
    $(@el).html(Haml.render(@template(), { locals: { option_type: option_type } }))
    return this
