#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers
#= require_tree ./libs
#= require ../common/manager_cookies
#= require ../common/carousel
#= require ../common/google_analytics
#= require ../common/graph
#= require ../common/analytics
#= require ../common/scan
#= require ../common/product_analytics 

@App =
  Models: {}
  Collections: {}
  Views: {} =
    Plans: {}
    Shops: {}
    Products: {}
    Customizations: {}
    Dashboard: {}
    Zones: {}
    ShippingCategories: {}
    ShippingMethods: {}
    ShopSettings: {}
    Analytics: {}
    Accounts: {}
    Administrators: {}
    Receipts: {}
    Promotions: {}
  Routers: {}
  Libs: {}

  init: ->
    new App.Routers.AccountSettings()
    new App.Routers.Plans()
    new App.Routers.Dashboard()
    new App.Routers.Products()
    new App.Routers.Orders()
    new App.Routers.ShippingCategories()
    new App.Routers.Wizards()
    new App.Routers.ShopSettings()
    new App.Routers.Analytics()
    new App.Routers.Promotions()
    Backbone.history.start()

    App.eventsDispatcher.on "fbSdkInit", () ->
      App.fbSdkInit = true

    loadingBox = new App.Views.LoadingBox()
    $(loadingBox.render().el).appendTo("body")

  set_active_nav_menu: ->
    $(".navbar.menu .nav_menu").removeClass("activate")
    url = window.location.hash
    regex = new RegExp("^.*(products|orders|customizations|analytics|dashboard|settings).*$")
    if(url.match(regex))
      cat = url.split(regex)[1]
      $("."+cat).addClass("activate")

App.eventsDispatcher = _.clone(Backbone.Events)

App.default_product_picture_url = "/assets/fallback/product_picture_default.jpg"

App.format_array_params_get_request = (params_name, array) ->
  params = ''
  for t in array
    params += "#{params_name}[]=#{t}&"
  return params

Array.prototype.contains = (obj) ->
  for item in @
    return true if item == obj
  return false

App.random_color = ->
  return "##{(Math.random()*0xFFFFFF<<0).toString(16)}"


App.date_now_utc = ->
  now = new Date()
  return Date.UTC(now.getFullYear(), now.getMonth(), now.getDate())

App.formatted_date = (date_utc) ->
  date = new Date(date_utc)
  if date.getDate() < 10
    day = "0#{date.getDate()}"
  else
    day = date.getDate()
  if (date.getMonth() + 1) < 10
    month = "0#{date.getMonth() + 1}"
  else
    month = date.getMonth() + 1
  year = date.getFullYear()
  return "#{day}/#{month}/#{year}"

App.to_en_date = (date) ->
  switch window.navigator.language
    when 'fr'
      return "#{date.split('/')[1]}-#{date.split('/')[0]}-#{date.split('/')[2]}"

App.day_to_utc = (n_day) ->
  return ((24 * 60 * 60) * 1000) * n_day

App.days_ago_to_utc = (day) ->
  d = new Date
  return Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()) - App.day_to_utc(day)

App.date_utc = (date) ->
  date = new Date(date)
  return Date.UTC(date.getFullYear(), date.getMonth(), date.getDate())

App.nb_days_by_range = (from, to) ->
  return (to - from) / App.day_to_utc(1)

App.next_day_utc = (date_utc, next = null) ->
  return date_utc + App.day_to_utc(next ? 1)

App.current_hostname = window.location.protocol + "//" + window.location.host

App.i18n = _.memoize () ->
  translate = new App.Translate
  translate.fetch
    async: false
  return translate

App.account = _.memoize () ->
  account = new App.Account
  account.fetch
    async: false
  return account

App.locale = _.memoize () ->
  lang = (window.navigator.language or navigator.userLanguage or "en").match(/^[a-z]{2}/)[0]
  lang = "en" if not lang.match /^(en|fr)$/
  return lang

App.devises = _.memoize () ->
  devises = new App.Collections.Devises
  devises.fetch
    async: false
  return devises

App.shop = _.memoize () ->
  shop = new App.Shop
  shop.id = App.getCookie("shop_id")
  shop.fetch
    async: false
  return shop

String.prototype.capitalize  = ->
  return this.charAt(0).toUpperCase() + this.slice(1)


App.deepExtend =  (object, extenders...) ->
  return {} if not object?
  for other in extenders
    for own key, val of other
      if not object[key]? or typeof val isnt "object"
        object[key] = val
      else
        object[key] = @deepExtend object[key], val
  object

Backbone.Collection.prototype.bulk_destroy = (models, options) ->
  throw new Error('Should pass ids') if _.isEmpty(models)
  success = options.success

  triggerDestroy = () =>
    model.trigger('destroy', model, @, options) for model in models

  options.success = (resp) =>
    triggerDestroy() if options.wait
    if success
      success(models, resp)
    else
      @.trigger('sync', models, resp, options)

  options.error = Backbone.wrapError(options.error, models, options)

  params =
    type: 'DELETE'
    dataType: 'json'

  model_ids = []
  for model in models
    model_ids.push model.get('id')


  params.data = {ids: model_ids}

  params.url = @.bulk_destroy_url()

  $.ajax(_.extend(params, options))
  triggerDestroy() if !options.wait


Backbone.Collection.prototype.bulk_copy = (models, options) ->
  throw new Error('Should pass ids') if _.isEmpty(models)
  success = options.success

  options.success = (resp) =>
    if success
      success(models, resp)
    else
      @.trigger('sync', models, resp, options)

  options.error = Backbone.wrapError(options.error, models, options)

  params =
    type: 'POST'
    dataType: 'json'

  model_ids = []
  for model in models
    model_ids.push model.get('id')

  params.data = {ids: model_ids}

  params.url = @.bulk_copy_url()

  $.ajax(_.extend(params, options))

$(document).ready ->
  App.init()
  App.set_active_nav_menu()
  window.location.hash = "#/choose" if window.location.pathname is "/plans"
  window.location.hash = "#/dashboard" if window.location.pathname is "/" and (window.location.hash is "" or window.location.hash is "#_=_")
  new App.Views.Shops.FB_Preview
  $('#new-shop').click (e) ->
    if $(e.currentTarget).attr('data-can-add') == "false"
      e.preventDefault()
      e.stopPropagation()
      new App.Views.Plans.BoxUpgrade
        message: $(e.currentTarget).attr('data-msg')
  return

$(window).bind 'hashchange', ->
  App.set_active_nav_menu()
