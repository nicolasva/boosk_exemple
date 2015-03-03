class App.Views.Products.LoadTitleProductToCartNumber extends Backbone.View
  template: JST["facebook/templates/products/load_title_product_to_cart_number"]

  initialize: (options) ->
    @render()

  render: ->
    @loading_title_product()

  loading_title_product: ->
    template = @template
    $('h3.title_product').each (data) ->
      class_title_product_id = $(this)
      product_id = $(this).attr("id").split("_")[$(this).attr("id").split("_").length-1]
      product = new App.Product(id: product_id)
      product.fetch
        success: (model, response) ->
          $(class_title_product_id).html(Haml.render(template(), {locals : {product_name: model.toJSON().name}})) 
