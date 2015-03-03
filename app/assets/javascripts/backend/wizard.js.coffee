#= require jquery
#= require jquery_ujs
#= require jquery-ui
#= require ../vendors/libraries-backend

#= require_self

#= require ../common/form_validate
#= require ../common/google_analytics
#= require ../common/manager_cookies

#= require_tree ./templates/wizards
#= require ./templates/loading_box.haml

#= require ./models/shop
#= require ./models/customization
#= require ./models/account
#= require ./models/translate
#= require ./models/devise
#= require ./models/geographic_region

#= require ./collections/devises
#= require ./collections/geographic_regions

#= require_tree ./views/wizards
#= require ./views/select_option
#= require ./views/loading_box
#= require ./routers/wizards

@App =
  Models: {}
  Collections: {}
  Views: {} =
    Shops: {}
  Routers: {}
  Libs: {}

  init: ->
    new App.Routers.Wizards()
    Backbone.history.start()
    loadingBox = new App.Views.LoadingBox()
    $(loadingBox.render().el).appendTo("body")

App.eventsDispatcher = _.clone(Backbone.Events)

$(document).ready ->
  App.init()
  window.location.hash = "/w_step1" if window.location.pathname == "/wizard"
  $('.chzn-select').chosen()
