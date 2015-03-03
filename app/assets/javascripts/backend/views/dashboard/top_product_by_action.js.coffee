class App.Views.Dashboard.TopProductsByAction extends Backbone.View
  el: '#top-products-by-action .content'
  template: JST["backend/templates/dashboard/top_products_by_action"]

  initialize: (options) ->
    @top_products = options.top_products
    @translate = options.translate
    @products = options.products
    @action = options.action
    @forbidden = options.forbidden
    @render()

  render: ->
    $(@el).html(Haml.render(@template(), {locals: {
      top_products: @top_products
      translate: @translate
      action: @action
      forbidden: @forbidden
      products: @products.toJSON()
    } }))
    return @
