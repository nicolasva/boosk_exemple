describe "confirm_drop_cartitem view mobile", ->
  beforeEach ->
    App.Views.Cart.ConfirmDropCartItem.prototype.template = JST["mobile/templates/cart/confirm_destroy_cart_item"]
    @event_target_id = "event_target_id_3_4"
    @product_id = 3
    @product_variant_id = 4
 
    @viewsCartConfirmDropCartItem = new App.Views.Cart.ConfirmDropCartitem({event_target_id: @event_target_id})

