class App.Views.Products.LoadTitleProductsToOrder extends Backbone.View
  initialize: (options) ->
    @tr_value_order = options.tr_value_order
    @render()

  render: ->
    @tr_value_order.each (index) ->
      el = this.id
      product_id = this.id.split("_")[this.id.split("_").length-1]
      product = new App.Product(id: product_id)