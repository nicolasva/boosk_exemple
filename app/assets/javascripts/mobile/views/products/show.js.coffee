class App.Views.Products.Show extends Backbone.View
  el: "#product_show"
  template: JST["mobile/templates/products/show"]

  template_see_more_product_variant_pictures: JST["mobile/templates/product_variants/show"]

  el_select_option_quantity: "#cart_item_quantity"
  template_quantity_for_product_variant: JST["mobile/templates/product_variants/option_type_quantity"]

  el_see_more_product_variant_pictures: "#box"

  el_title: "#title"

  id_form_add_to_cart: '#form_add_to_cart'

  events:
    "submit #form_add_to_cart": "add_to_cart_mobile"
    "click .see_more": "see_more_product_variant_pictures"
    "change #option-types select": "change_product_variant"
    "click .track.like_it":  "like_it"
    "click .track.tweet_it": "tweet_it"
    "click .track_all": "track"
    "click .track.pint_it":  "pint_it"

  initialize: (options) ->
    @translate = options.translate
    @product = options.product
    @shop = options.shop
    @option_types = options.option_types
    @product_variants = new App.Collections.ProductVariants(@product.getVariants())
    @variant_option_types = @product_variants.getOptionTypes()
    @save_options_selected = []
    @width_img = -1
    @total_slides = -1
    @render()

  render: ->
    _.bindAll @
    $("#title").hide()
    $(".product_lists").hide()
    $("#product_show").show()
    quantity_product = @number_quantity_product(@product_variants.getMaster().toJSON())
    $("#header").hide()
    $(@el).html(Haml.render(@template(), {
      locals: {
        shop: @shop.toJSON()
        product: @product.toJSON()
        product_variant_master: @product_variants.getMaster().toJSON()
        quantity_product: quantity_product
        variant_option_types: @variant_option_types
        option_types: @option_types.toJSON()
        translate: @translate.toJSON()
        options_unselectable: @product_variants.check_init_option_type_unselectable(@option_types.toJSON())
      }
    }))

    @product_variant_pictures = new App.Views.Products.ChangeProductsVariantPictures(product_variants_selected: @product_variants.getMaster(), product: @product, translate: @translate)
    @init_hammer()

  init_hammer: ->
    hammer = new Hammer($(".photo_product").children()[0],
      hold: false,
      tap: false,
      tap_double: false,
      drag: true,
      drag_vertical: false,
      drag_horizontal: true,
      transform: false,
      drag_min_distance: 5,
      prevent_default: true
    )

    self = @
    hammer.ondragend = (ev) ->
      slide = $(".photo_product>ul")[0]
      if self.width_img == -1
        self.width_img = parseInt($($(slide).children()[0]).outerWidth())
        self.total_slides = parseInt($(slide).attr("data-max-img"))
      current_img = $(slide).attr("data-current-img")
      pos = parseInt($(slide).attr("data-position"))
      if ev.direction == 'left' && current_img < self.total_slides
        pos = pos - self.width_img
        current_img++
      else if ev.direction == 'right' && current_img > 1
        pos = pos + self.width_img
        current_img--
      $(slide).attr("data-current-img", current_img)
      $(slide).animate
        "margin-left": pos, 
        500
      $(slide).attr("data-position", pos)
      $(".overview_photo_product ul>li").removeClass("activate")
      $($(".overview_photo_product ul>li")[current_img-1]).addClass("activate")

  like_it: (event) ->
    location = document.URL.split("#")[0]+"#/products/"+event.target.id.split("_")[event.target.id.split("_").length-1]
    @viewShareItFacebook = new App.CommonViews.Pint.LikeItFacebook(location: location)

  tweet_it: (event) ->
    location = document.URL.split("#")[0]+"#/products/"+event.target.id.split("_")[event.target.id.split("_").length-1]
    @viewTweetItTwitter = new App.CommonViews.Twitter.TweetIt(location: location)

  pint_it: (event) ->
    product_data_ref = $(event.target).parent().parent().parent().parent().attr("data-ref")
    url_path = "http://"+window.location.hostname
    location = document.URL.split("#")[0]+"#/products/"+event.target.id.split("_")[event.target.id.split("_").length-1]
    product = new App.Product(id: product_data_ref)
    product.fetch
      success: (model, response) ->
        @viewPintItPinterest = new App.CommonViews.Pint.PintItPinterest(product: model, location: location, url_path: url_path)

  track: (event) ->
    data_params =
      open_graph:
        type: $(event.target).attr("class").split(" ")[2].split("_")[0]
    product_id = $(event.target).parent().parent().parent().parent().attr("data-product-id")
    $.ajax({
      url: "/facebook/shops/#{App.current_shop}/products/#{product_id}/open_graphs"
      type: "POST"
      data: data_params,
      dataType: "json"
      success: (data) ->
        console.log data
      error: (data) ->
        alert "error"
    })

  change_product_variant: (event) ->
    valid_button_submit = true
    $(".option_types_select").find("option:selected").each (key,val) ->
      valid_button_submit = false if $(val).attr("value") == "undefined"
    @variant_options = new App.Views.Products.ChangeOptionTypes(option_types: @option_types, product_variants: @product_variants, target: $(event.target), variant_option_types: @variant_option_types, save_options_selected: @save_options_selected, translate: @translate) 
    @product_variant_pictures = new App.Views.Products.ChangeProductsVariantPictures(product_variants_selected: @variant_options.variant_selected, product: @product, translate: @translate)
    
    el_select_option_quantity: "#cart_item_quantity"
    template_quantity_for_product_variant: JST["mobile/templates/produt_variants/option_type_quantity"]
    $(@el_select_option_quantity) .html(Haml.render(@template_quantity_for_product_variant(), {locals: {quantity_product: @number_quantity_product(@variant_options.variant_selected.toJSON())}}))
    if parseInt(@variant_options.variant_selected.toJSON().quantity) == 0
      $("#submit_cart").attr("class", "btn btn-warning span12")
      $(@el_select_option_quantity).attr("disabled", "disabled")
    else
      if valid_button_submit
        $("#submit_cart").attr("class", "add_to_cart orange span12")
        $("#submit_cart").removeAttr("disabled")
        $(@el_select_option_quantity).removeAttr("disabled")
      else
        $("#submit_cart").attr("class", "btn btn-warning span12")
        $("#submit_cart").attr("disabled", "disabled")
        $(@el_select_option_quantity).attr("disabled", "disabled")

    @width_img = -1
    @total_slides = -1
    @init_hammer()

  add_to_cart_mobile: (event) ->
    data = $(@id_form_add_to_cart).toJSON() 
    quantity = data.cart_item.quantity
    @carts = new App.Collections.Carts()
    product_id = data.cart_item.product_id
    product_variant_id = data.cart_item.product_variant_id
    @carts.fetch
      success: (collection, response) ->
        @viewcartaddtocart = new App.Views.CartItems.AddToCart(carts: collection, product_id: product_id, product_variant_id: product_variant_id, quantity: quantity, data: data)
    return false
 
  see_more_product_variant_pictures: (event) ->
    @ViewProductVariantsShow = new App.Views.ProductVariants.Show({product_variants: @product.toJSON().product_variants})

  number_quantity_product: (product_variant_master) ->
    array_quantity = new Array()
    if product_variant_master.quantity > 0
      for num in [1..parseInt(product_variant_master.quantity)]
        array_quantity.push(num)
    else
      array_quantity.push(0)
    array_quantity

  get_product_variants_pictures: (product_variants) ->
    compteur = 0
    if product_variants.length > 4
      array_product_variants = new Array()
      while compteur < 5
        array_product_variants.push(product_variants[compteur])
        compteur += 1
      array_product_variants
    else
      product_variants
