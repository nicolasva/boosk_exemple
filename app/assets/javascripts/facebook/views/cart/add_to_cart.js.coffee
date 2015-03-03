class App.Views.Cart.AddToCart extends Backbone.View
  initialize: (options) ->
    @cartitems = @options.cartitems
    @product_id = @options.product_id
    @quantity = @options.quantity
    @product_variant_id = @options.product_variant_id
    @select_add_to_cart()

  select_add_to_cart: ->
    self = @
    if @cartitems.get(@product_variant_id)
      @cart = new App.Cart(quantity: @quantity)
      @cartitems.remove(@cartitems.get(@product_variant_id))
      @cart.product_id = @product_id  
      @cart.product_variant_id = @product_variant_id
      @cart.save(@cart,{
        success: (cart) ->
          @carts = new App.Collections.CartItems()
          @carts.fetch 
            success: (collections, response) ->
              @ViewCartNumber = new App.Views.Cart.CartNumber(cartitems: collections)
            error: (cart) ->
              alert("error")
      })
      
    else
      @cart = new App.Cart()
      @cart.product_id = @product_id  
      @cart.product_variant_id = @product_variant_id
      product_variant_id = @product_variant_id
      @cart.save(@cart,{
        success: (cart) ->
          @carts = new App.Collections.CartItems()
          @carts.product_id = cart.toJSON().product.product_id
          @carts.product_variant_id = cart.toJSON().product.id 
          @carts.fetch 
            success: (collections, response) ->
              @ViewCartNumber = new App.Views.Cart.CartNumber(cartitems: collections)
            error: (cart, data) ->
              @commonviewsNoticeNotice = new App.CommonViews.Notice.Notice({data: data, el: '#notice', notice_style: App.noticeStyleBox()})
      })
