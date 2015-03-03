class App.Views.ProductVariants.ShowDetailProductVariants extends Backbone.View
  el: "#app_mobile"
  template: JST["mobile/templates/products/show"]

  events:
    "submit #form_add_to_cart": "add_to_cart_mobile"
    "click .img_product_variant": "change_product_variant" 
    "click .see_more": "see_more_product_variant_pictures"
 
  initialize: (options) ->
    @productVariant = options.productVariant 
    @render()

  render: ->
    productVariant = @productVariant
    el = @el
    template = @template()
    @option_type = new App.OptionType()
    get_product_variants_pictures = @get_product_variants_pictures(@productVariant.toJSON())
    quantity_product = @number_quantity_product(@productVariant.toJSON()) 
    @option_type.fetch
      success: (model, response) ->
        $(el).html(Haml.render(template, { locals: {product: productVariant.toJSON().product, product_variant_master: productVariant, quantity_product: quantity_product, option_types: model.toJSON(), product_variant_pictures: get_product_variants_pictures}}))
 
  number_quantity_product: (product_variant_master) ->
    array_quantity = new Array()
    for num in [1..parseInt(product_variant_master.quantity)]
      array_quantity.push(num)
    array_quantity

  get_product_variants_pictures: (product_variants) ->
    array_product_variants = new Array()
    compteur = 0
    if product_variants.length > 4
      while compteur < 5
        array_product_variants.push(product_variants[compteur])
        compteur += 1
      array_product_variants
    else
      product_variants

  add_to_cart_mobile: (event) ->
    data = $(@id_form_add_to_cart).toJSON()
    quantity = data.cart.quantity
    @cartitems = new App.Collections.CartItems()
    product_id = data.cart.product_id
    product_variant_id = data.cart.product_variant_id
    @cartitems.fetch
      success: (collection, response) ->
        @viewcartaddtocart = new App.Views.CartItems.AddToCart(cartitems: collection, product_id: product_id, product_variant_id: product_variant_id, quantity: quantity) 
    return false

  change_product_variant: (event) ->
    el = @el
    template = @template
    product = @product
    product_variant_id = event.target.id.split("_")[event.target.id.split("_").length-1]
    product_variants = @product.toJSON().product_variants
    product_variant_master = @product.toJSON().product_variants[0]
    quantity_product = @number_quantity_product(product_variant_master) 
    $.each(product_variants, (key, val) ->
      if parseInt(val.id) == parseInt(product_variant_id)
        product_variant_master = val 
        option_type = new App.OptionType()
        option_type.fetch
          success: (model, response) ->
            $(el).html(Haml.render(template(), { locals: {product: product.toJSON(), product_variant_master: product_variant_master, option_types: model.toJSON(), quantity_product: quantity_product}}))
    )

  see_more_product_variant_pictures: (event) ->  
    #template_see_more_product_variant_pictures: JST["mobile/templates/product_variants/show"]
    #el_see_more_product_variant_pictures: "#box" 
    @ViewProductVariantsShow = new App.Views.ProductVariants.Show({product_variants: @product.toJSON().product_variants})
    #$(@el_see_more_product_variant_pictures).html(Haml.render(@template_see_more_product_variant_pictures(), { locals: {product_variants: @product.toJSON().product_variants}}))
    #@ViewCommonviewsBoxresizeBoxresize = new App.CommonViews.BoxResize.BoxResize({el_box: @el_see_more_product_variant_pictures, width: "400px", height: "400px", background_color: "white", color: "black"})
    #$(@el_see_more_product_variant_pictures).modal('show')
