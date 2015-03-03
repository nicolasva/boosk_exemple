class App.Collections.Products extends Backbone.Collection
  model: App.Product

  url: ->
    "/#{App.ui()}/shops/#{App.current_shop}/products?#{$.param(@query_params)}"
