class App.Routers.ShippingCategories extends Backbone.Router
  routes:
    "/shipping_categories":          "index"
    "/shipping_categories/new":      "new"
    "/shipping_categories/:id/edit": "edit"

  initialize: ->
    @shipping_categories = new App.Collections.ShippingCategories()

  index: ->
    @shipping_categories.fetch
      success: (collection, response) ->
        @view = new App.Views.ShippingCategories.Index(collection: collection)
        $("#app").html(@view.render().el)

  new: ->
    @view = new App.Views.ShippingCategories.New(collection: @shipping_categories)
    $("#app").html(@view.render().el)

  edit: (id) ->
    @shipping_categories.fetch
      success: (collection, response) ->
        shipping_category = collection.get(id)
        @view = new App.Views.ShippingCategories.Edit(model: shipping_category)
        $("#app").html(@view.render().el)
