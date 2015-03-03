#= require_self
#= require_tree ./templates
#= require_tree ./common_templates
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ../facebook/common_views
#= require_tree ./routers
#= require_tree ./libs
#= require ../common/manager_cookies
#= require ../common/notice
#= require ../common/carousel
#= require ../common/get_product_variant_master
#= require ../common/nb_products_total
#= require ../common/create_dynamic_page
#= require ../common/routing_ui_detection
#= require ../common/common

@App =
  Models: {}
  Collections: {}
  CommonViews: {} =
    BoxResize: {}
    Notice: {}
    Pint: {}
    Twitter: {}
    Products: {}
    Checkouts: {}
    ProductVariants: {}
    Customizations: {}
  Views: {} =
    Products: {}
    Shops: {}
    Orders: {}
    Cart: {}
    Checkout: {}
    ProductVariantPictures: {}
    Customizations: {}
    Taxonomies: {}
  Routers: {}
  Libs: {}
  preview: false
  init: ->
    new App.Routers.Products()
    new App.Routers.Shops()
    new App.Routers.Orders()
    new App.Routers.Checkout()
    Backbone.history.start()
    App.preview = true if getUrlVars()['preview'] != undefined
    $('.track').live 'click', App.tracker if App.preview isnt true
    App.eventsDispatcher.on "fbSdkInit", () ->
      App.fbSdkInit = true
    return

App.eventsDispatcher = _.clone(Backbone.Events)

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

App.ui = ->
  if !_.isNull(window.location.pathname.match(/^\/(mobile|facebook)/))
    return window.location.pathname.match(/^\/(mobile|facebook)/)[1]
  else
    return "facebook"

App.total_cart = (model_cart) ->
  total = 0
  for item in model_cart
    attr = item.attributes
    total += (attr.product.price * attr.quantity)
  return total

App.current_shop = App.getCookie("front_shop_id")

$(document).ready ->
  App.init()
  App.current_shop = App.getCookie("front_shop_id")
  $(".show-cgv").click (e) ->
    $('#cgv').on 'shown', (e) ->
      $('.modal-backdrop').addClass('white-overlay')
    $('#cgv').on 'hide', (e) ->
      $('.modal-backdrop').removeClass('white-overlay')
    $('#cgv').modal('show')
  return
