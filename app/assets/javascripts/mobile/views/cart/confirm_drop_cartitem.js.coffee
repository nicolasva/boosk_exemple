class App.Views.Cart.ConfirmDropCartitem extends Backbone.View
  el: "#box"
  template: JST["mobile/templates/cart/confirm_destroy_cart_item"]

  events:
    "click .confirm_yes_destroy_item" : "confirm_destroy_yes"
    "click .confirm_no_destroy_item" : "confirm_destroy_no"
    
  initialize: (options) ->
    @event_target_id = @options.event_target_id
    @product_id = @event_target_id.split("_")[@event_target_id.split("_").length-1]
    @product_variant_id = @event_target_id.split("_")[@event_target_id.split("_").length-2] 
    @render()

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {product_id: @product_id, product_variant_id: @product_variant_id}}))
    @CommonviewsBoxResizeBoxResize = new App.CommonViews.BoxResize.BoxResize({el_box: @el, width: "230px", height: "90px", background_color: "white", color: "black", padding_left: "50px", padding_right: "50px", padding_bottom: "25px", padding_top: "30px", text_align: "left"})
    $(@el).modal('show')

  confirm_destroy_yes: (event) ->
    $.ajax
      url: "/shops/"+App.current_shop+"/delete_to_cart/"+@product_variant_id
      type: "DELETE"
      cache: false
      dataType: "script"
      success: (model, cartitem) ->
        @carts = new App.Collections.Carts()
        @carts.fetch
          success: (collection, carts) ->
            @viewnumberproduct = new App.Views.CartItems.NumberProduct(carts: collection) 
            if _.isEmpty(collection.toJSON())
              window.location.hash = "#/shops/#{App.current_shop}"
            else
              window.location.hash = "#/carts/edit"

    $(@el).modal('hide')

  confirm_destroy_no: (event) ->  
    $(@el).modal('hide') 
