class App.Views.Cart.Edit extends Backbone.View
  el: "#checkout"
  template: JST["mobile/templates/cart/edit"]

  events:
    "click .cart_remove" : "drop_cart"
    "change .cart_items_quantity" : "cartitems_edit"

  initialize: (options) ->
    @translate = options.translate
    @carts = @options.carts
    @render()

  render: ->
    $("#header").hide()
    $(".product_lists").hide()
    $("#product_show").hide()
    $("#checkout").show()
    $(@el).html(Haml.render(@template(), { locals: {
      cartitems: @carts.toJSON()
      total_cart: @carts.total
      translate: @translate.toJSON()
    }}))
    $.each($("#form_edit_cart_items").children().first().children().first().children(), (key, val) ->
      unless val.id == "title_table" || val.id == "tr_total"
        product_id = parseInt(val.id.split("_")[val.id.split("_").length-1])
        product_variant_id = parseInt(val.id.split("_")[val.id.split("_").length-3])
        product_variant = new App.ProductVariant(id: product_variant_id)
        product_variant.product_id = product_id
        product_variant.fetch
          success: (models, response) ->
            $.each(models.toJSON().pictures, (key, value) ->
              if value.is_master
                $(val).children().first().html("<img src='"+value.picture.url+"' alt='"+value.picture.url+"'>") 
            )
    )

  cartitems_edit: (event) ->
    product_variant_id = $(event.target).parent().children().first().attr("value")
    quantity = parseInt($(event.target).attr('value'))
    @cart = new App.Cart()
    if @cart.get(product_variant_id)
      @carts.remove(@carts.get(product_variant_id)) if @carts.get(product_variant_id)
    hash_params_edit_cart =
      cart_item:
        product_variant_id: product_variant_id
        quantity: quantity
    @cartitem = new App.CartItem()
    @cartitem.page = "update_to_cart"
    @cartitem.save(hash_params_edit_cart, {
      success: (cartitem) ->
        @viewCartTotalPriceUpdateToTable = new App.Views.CartItems.CartUpdatePriceToTable(cartitem: cartitem, el: $($(event.target).parent().parent().children()[3]))
        @viewCartItemsUpdateTotalPriceAllProductToTable = new App.Views.Cart.UpdateTotalPriceAllProductToTable()
    })

  quantity_select: (carts, product_variant_id, event) ->
    quantity = 1
    if carts.get(product_variant_id)
      quantity = @carts.get(product_variant_id).toJSON().quantity
    else
      quantity = $(event.target).parent().children().first().html()
    quantity

  drop_cart: (event) ->
    if event.target.id.length > 0
     event_target_id = event.target.id
    else
     event_target_id = $(event.target).parent().first().attr("id")

    @ViewCartitemsConfirmDropCartitem = new App.Views.Cart.ConfirmDropCartitem(event_target_id: event_target_id)
