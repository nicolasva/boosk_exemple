#= require_self
#= require_tree ./templates
#= require_tree ../facebook/common_templates
#= require_tree ../facebook/models
#= require_tree ./models
#= require_tree ../facebook/collections
#= require_tree ../facebook/common_views
#= require_tree ./views
#= require_tree ./routers
#= require ../common/get_product_variant_master
#= require ../common/nb_products_total
#= require ../common/create_dynamic_page
#= require ../common/nb_products_total
#= require ../common/fixed_price

@App =
  Models: {}
  Collections: {}
  CommonViews: {} =
    BoxResize: {}
    Notice: {}
    Pint: {}
    Products: {}
    Checkouts: {}
    Twitter: {}
    Customizations: {}
    ProductVariants: {}
  Views: {} =
    PathPanel: {}
    Shops: {}
    Taxonomies: {}
    Taxons: {}
    Products: {}
    Checkouts: {}
    Cart: {}
    CartItems: {}
    Customizations: {}
    ProductVariants: {}
    OptionTypes: {}
    Panel: {}
  Routers: {}
  Libs: {}
  init: ->
    new App.Routers.Shops()
    new App.Routers.Taxonomies()
    new App.Routers.Products()
    new App.Routers.Carts()
    new App.Routers.ProductVariants()
    new App.Routers.Checkout()
    Backbone.history.start()
    return

App.getCookie = (name) ->
  result = ""
  regSepCookie = new RegExp('(; )', 'g')
  cookies = document.cookie.split(regSepCookie)
  i = 0
  while i < cookies.length
    regInfo = new RegExp('=', 'g')
    infos = cookies[i].split(regInfo)
    if infos[0] == name
      result = unescape(infos[1])
    i += 1
  result

App.number_quantity_product = (quantity) ->
  array_quantity = new Array()
  for num in [1..parseInt(quantity)]
    array_quantity.push(num)
  array_quantity

App.ui = ->
  if !_.isNull(window.location.pathname.match(/^\/(mobile|facebook)/))
    return window.location.pathname.match(/^\/(mobile|facebook)/)[1]
  else
    return "mobile"

App.noticeStyle = ->
  notice_style =
    style:
      background_color: "green"
      color: "black"
      border: "none"

App.noticeStyleBox = ->
  notice_style_box =
    style:
      background_color: "green"
      color: "black"
      border: "none"

App.total_cart = (model_cart) ->
  total = 0
  for item in model_cart
    attr = item.attributes
    total += (attr.product.price * attr.quantity) unless _.isUndefined(attr.product)
  return total

App.current_shop = App.getCookie("front_shop_id")

App.setCookie = (c_name, value) ->
  exdate = new Date()
  exdate.setDate(exdate.getDate() + 1)
  cookie = c_name+"="+value+";expires="+exdate.toUTCString()
  document.cookie = cookie

App.delCookie = (name) ->
  document.cookie = name + "=; expires=Thu, 01-Jan-70 00:00:01 GMT;"

App.devise = (value) ->
  devise = "$"
  devise = "€" if value == "EUR"
  return devise

$(document).ready ->
  App.init()
  return
