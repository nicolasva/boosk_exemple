class App.Collections.ShippingCategories extends Backbone.Collection
  model: App.ShippingCategory
  url: ->
    base = "/shops/#{App.current_shop}/shipping_categories"
