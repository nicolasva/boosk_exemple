App.Views.ShippingCategories ||= {}

class App.Views.ShippingCategories.New extends Backbone.View
  template: JST["backend/templates/shipping/categories/new"]

  form_id: '#new_shipping_category_form'

  events:
    "submit #new_shipping_category_form": "save"

  initialize: (options) ->
    super(options)
    @model = new @collection.model()
    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()
    self = @
    @collection.create($(@form_id).toJSON(),
      success: (shipping_category) =>
        window.location.hash = "#/shipping_categories"
      error: (shipping_category, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(Haml.render(@template(), { locals: { shipping_category: @model.toJSON()} }))
    return this
