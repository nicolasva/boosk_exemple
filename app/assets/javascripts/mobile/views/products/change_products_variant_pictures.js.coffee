class App.Views.Products.ChangeProductsVariantPictures extends Backbone.View
  el: '.all_product_variant_pictures' 

  template: JST["mobile/templates/products/change_variant_pictures"]

  initialize: (options) ->
    @translate = options.translate
    @product_variants_selected = options.product_variants_selected
    @ViewPanelSetAttributesAfterAction = new App.CommonViews.ProductVariants.ChangePriceWithVariant({price: @product_variants_selected.toJSON().price_ttc})
    @product = options.product
    @setElement(@el)
    @render()

  render: ->
    $(@el).html(Haml.render(@template(), { locals: { 
      product_variants: @product_variants_selected.toJSON(),
      product: @product.toJSON()
    }}))
    $("#cart_item_product_variant_id").attr("value", @product_variants_selected.toJSON().id)
