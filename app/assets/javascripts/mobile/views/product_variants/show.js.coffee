class App.Views.ProductVariants.Show extends Backbone.View
  template: JST["mobile/templates/product_variants/show"]
  el: "#box"

  events:
    "click .img_product_variant": "load_product_variant"

  initialize: (options) ->
    @product_variants = options.product_variants
    @render()

  render: ->
    $(@el).html(Haml.render(@template(), {locals: {product_variants: @product_variants}})) 
    @ViewCommonviewsBoxresizeBoxresize = new App.CommonViews.BoxResize.BoxResize({el_box: @el, width: "400px", height: "400px", background_color: "white", color: "black"})
    $(@el).modal('show')

  load_product_variant: (event) ->
    product_variant_id = event.target.id.split("_")[event.target.id.split("_").length-1]
    product_id = event.target.id.split("_")[event.target.id.split("_").length-2]
    location.hash = "/products/"+product_id+"/product_variants/"+product_variant_id
    
