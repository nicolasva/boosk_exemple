class App.Views.CartItems.AddToCart extends Backbone.View
  initialize: (options) ->
    @carts = @options.carts
    @product_id = @options.product_id
    @quantity = @options.quantity
    @data = options.data
    @product_variant_id = @options.product_variant_id
    @select_add_to_cart()

  select_add_to_cart: ->
    if @valid_add_cart()
      if @carts.get(@product_variant_id)
        hash_params_edit_cart = 
          cart_item:
            product_variant_id: @product_variant_id
            quantity: parseInt(@quantity) + parseInt(@carts.get(@product_variant_id).attributes.quantity)
        @cartitem = new App.CartItem()
        @carts.remove(@carts.get(@product_variant_id))
        @cartitem.page = "update_to_cart"
        @cartitem.save(hash_params_edit_cart,{
          success: (cartitem) ->
            @carts = new App.Collections.Carts()
            @carts.fetch 
              success: (collections, response) ->
                 @viewnumberproduct = new App.Views.CartItems.NumberProduct(carts: collections)
          error: (cartitem, data) ->
            @view_select_choice_option_types = new App.Views.OptionTypes.OptionTypesSelect(model_error: cartitem.errors[0])
        })
      else
        $.ajax
          data: @data
          url: "/shops/"+App.current_shop+"/add_to_cart"
          type: "POST"
          cache: false
          dataType: "script"
          success: (data) ->
            @carts = new App.Collections.Carts()
            @carts.fetch 
              success: (collections, response) ->
                @viewnumberproduct = new App.Views.CartItems.NumberProduct(carts: collections)

  valid_add_cart: ->
    valid = true
    unless _.isUndefined(@data.cart_item.option_type)
      option_type = @data.cart_item.option_type 
      $.each(option_type, (key,val) ->
        valid = false if val == "undefined"
      )
    return valid

