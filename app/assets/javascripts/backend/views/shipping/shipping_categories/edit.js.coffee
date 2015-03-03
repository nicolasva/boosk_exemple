App.Views.ShippingCategories ||= {}

class App.Views.ShippingCategories.Edit extends Backbone.View
  template: JST["backend/templates/shipping/categories/edit"]

  form_id: '#edit_shipping_category_form'

  events:
    "submit #edit_shipping_category_form": "update"

  initialize: (options) ->
    super(options)
    @model.bind("change:errors", () =>
      this.render()
    )

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()
    self = @
    @model.save($(@form_id).toJSON(),
      success: (shipping_category) =>
        window.location.hash = "#/shipping_categories"
      error: (shipping_category, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(Haml.render(@template(), { locals: { shipping_category: @model.toJSON()} }))
    return this
