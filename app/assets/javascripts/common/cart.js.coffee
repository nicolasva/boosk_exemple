$("#add_to_cart input[type='submit']").live "click", ->
  token = true
  $("form#add_to_cart").find("#option-types select").each (index) ->
    if(isNaN(this.value))
      token = false
      return false
      #add class required

  product_variant_id = $("#add_to_cart #modal_variant_id")[0].value
  quantity = Number($("#add_to_cart #modal_quantity")[0].value)
  $(".cart_item").each ->
    if $(this).attr("data-variant-id") == product_variant_id
      token = false
      $.ajax
        data: {cart_item: {product_variant_id: product_variant_id, quantity: quantity}}
        url: "/shops/"+App.current_shop+"/update_to_cart"
        type: "POST"
        cache: false
        dataType: "script"
        success: ->
          $(".btn-group").addClass("open")
      return false
  if token
    if !isNaN(quantity)
      $.ajax
        data: {cart_item: {product_variant_id: product_variant_id, quantity: quantity}}
        url: "/shops/"+App.current_shop+"/add_to_cart"
        type: "POST"
        cache: false
        dataType: "script"
        success: ->
          $("#modal").modal('hide')
          $(".btn-group").addClass("open")
  return false

$(".cart_add_enabled").live "click", (event) ->
  cart_item = $(event.target).closest(".cart_item")
  product_variant_id = cart_item.attr("data-variant-id")
  quantity = parseInt(cart_item.attr("data-quantity"))+1
  set_quantity_cart_item(product_variant_id, quantity)
  return false

$(".cart_less_enabled").live "click", (event) ->
  cart_item = $(event.target).closest(".cart_item")
  product_variant_id = cart_item.attr("data-variant-id")
  quantity = parseInt(cart_item.attr("data-quantity"))-1
  set_quantity_cart_item(product_variant_id, quantity)
  return false

set_quantity_cart_item = (product_variant_id, quantity) ->
  $.ajax
    data: {cart_item: {product_variant_id: product_variant_id, quantity: quantity}}
    url: "/shops/"+App.current_shop+"/update_to_cart"
    type: "POST"
    cache: false
    dataType: "script"
    success: ->
      $(".btn-group").addClass("open")

$(".cart_remove").live "click", (event) ->
  cart_item = $(event.target).closest(".cart_item")
  product_variant_id = cart_item.attr("data-variant-id")
  $.ajax
    url: "/shops/"+App.current_shop+"/delete_to_cart/"+product_variant_id
    type: "DELETE"
    cache: false
    dataType: "script"
    success: ->
      $(".btn-group").addClass("open")

$("#clean_cart").live "click", ->
  $.ajax
    url: "/shops/"+App.current_shop+"/clean_carts"
    type: "DELETE"
    cache: false
    dataType: "script"
