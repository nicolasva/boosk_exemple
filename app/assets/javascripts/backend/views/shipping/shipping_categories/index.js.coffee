App.Views.ShippingCategories ||= {}

class App.Views.ShippingCategories.Index extends Backbone.View
  template: JST["backend/templates/shipping/categories/index"]

  events:
   "click .destroy" : "destroy"

  destroy: (event) ->
    id = $(event.target).attr('data-id')
    shipping_category = @collection.get(id)
    shipping_category.destroy
      success: (data, reponse) ->
        $(event.target).parent('td').parent('tr').remove()

  render: ->
    $(@el).html(Haml.render(@template(), { locals: { shipping_categories: @collection.toJSON()} }))
    return this