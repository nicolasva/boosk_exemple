class App.Views.Cart.AddQuantity extends Backbone.View
  initialize: (options) ->
    @product = options.product
    @product_variant_id = options.product_variant_id
    @cartitems = options.cartitems
    @render()

  render: ->
    product_id = @product.toJSON().id
    product_variant_id = @product_variant_id
    if @cartitems.get(product_variant_id)
      quantity = parseInt(@cartitems.get(product_variant_id).toJSON().quantity) + 1
      @cartitems.remove(@cartitems.get(product_variant_id)) if @cartitems.get(product_variant_id)
    else
      quantity = parseInt($("#id_value_quantity_"+product_variant_id).html()) + 1
    quantity_max = @quantity_max(@product.toJSON().product_variants)
    quantity = quantity_max if quantity > quantity_max
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
    

  quantity_max: (product_variants) ->
    quantity = product_variants[0].quantity
    $.each(product_variants, (key, val) ->
      quantity = val.quantity if val.id == @product_variant_id
    )
    quantity
