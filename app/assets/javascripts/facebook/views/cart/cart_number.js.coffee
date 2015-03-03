class App.Views.Cart.CartNumber extends Backbone.View
  el: '#menu1'
  template: JST["facebook/templates/cart/cart_number"]

  events:
    "click .add_quantity" : "add_quantity"
    "click .less_quantity" : "less_quantity"
    "click .link_destroy_basket_shop" : "destroy_basket_shop"
    "click .destroy_all_basket" : "destroy_all_basket"

  initialize: (options) ->
    @cartitems = @options.cartitems
    @render()

  total_cartitems: ->
    @cartitems.models.length
     
  render: -> 
    $(@el).html(Haml.render(@template(), { locals: {
      total_cartitems: @total_cartitems(), shop_id: App.current_shop, cartitems: @cartitems.toJSON()     
    }}))
    if @total_cartitems() > 0 
      @viewLoadImgProductVariantpicture = new App.Views.ProductVariantPictures.LoadImgProductVariantPictureFirst()
      @viewLoadTitleProductToCartNumber = new App.Views.Products.LoadTitleProductToCartNumber()
      @viewCartTotalBasket = new App.Views.Cart.TotalBasket()

  add_quantity: (event) ->
    cartitems = @cartitems
    product_id = event.target.id.split("_")[event.target.id.split("_").length-1] 
    product_variant_id = event.target.id.split("_")[event.target.id.split("_").length-2]
    @product = new App.Product(id: product_id)
    @product.fetch
      success: (models, response) ->
        @ViewCartAddQuantity = new App.Views.Cart.AddQuantity(product: models, product_variant_id: product_variant_id, cartitems: cartitems) 
  
  less_quantity: (event) ->
    @cart = new App.Cart()
    product_id = event.target.id.split("_")[event.target.id.split("_").length-1]
    product_variant_id = event.target.id.split("_")[event.target.id.split("_").length-2]   
    if @cartitems.get(product_variant_id) 
      quantity = parseInt(@cartitems.get(product_variant_id).toJSON().quantity) - 1
      @cartitems.remove(@cartitems.get(product_variant_id)) if @cartitems.get(product_variant_id)
    else 
      quantity = $("#id_value_quantity_"+product_variant_id).html() - 1
    quantity = 1 if parseInt(quantity) < 2 
    @cart = new App.Cart(id: quantity)
    @cart.product_id = product_id
    @cart.product_variant_id = product_variant_id 
    @cart.save(@cart,{
      success: (cart) ->
        cart.fetch 
          success: (models, response) ->
            @viewLoadDetailBasket = new App.Views.Cart.LoadDetailBasket(cart: models)
            @viewCartNumberUpdate = new App.Views.Cart.CartNumberUpdate(cart: models)
            @viewLoadTitleProductToCartNumber = new App.Views.Products.LoadTitleProductToCartNumber()
            @viewCartTotalBasket = new App.Views.Cart.TotalBasket()
    })
    $('.dropdown-menu').show()
    return false

  destroy_basket_shop: (event) ->
    product_variant_id = event.target.id.split("_")[event.target.id.split("_").length-1]
    product_id = event.target.id.split("_")[event.target.id.split("_").length-2]
    @cart = new App.Cart(id: product_variant_id)
    @cart.product_variant_id = product_variant_id
    @cart.product_id = product_id
    @cart.fetch 
      success: (models, response) ->
        models.destroy
          success: (cart, data) ->
            $("#cartitem_show_basket_"+product_variant_id).remove()
            nb_basket_shop_update = parseInt($($("#menu1").children()[0]).children().html().split("(")[1].split(")")[0]) - 1
            $($("#menu1").children()[0]).children().html("(" + nb_basket_shop_update + ")")
            @viewCartTotalBasket = new App.Views.Cart.TotalBasket()

  destroy_all_basket: (event) ->
    @cartitem = new App.CartItem(id: "destroy")
    @cartitem.fetch 
      success: (model, response) ->
        model.destroy
          success: (cartitem, data) ->
            @cartitems = new App.Collections.CartItems()
            @cartitems.fetch
              success: (collections, response) ->
                @ViewCartNumber = new App.Views.Cart.CartNumber(cartitems: collections)
