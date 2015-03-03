#= require jquery
#= require jquery_ujs
#= require jquery-ui
#= require ../vendors/libraries-backend

#= require_self

#= require ../common/form_validate
#= require ../common/google_analytics
#= require ../common/manager_cookies
#= require ./libs/utils

#= require_tree ./templates/plans
#= require ./templates/loading_box.haml

#= require ./models/plan
#= require ./models/account
#= require ./models/translate
#= require ./models/user_plan

#= require ./collections/plans
#= require_tree ./views/plans
#= require ./views/loading_box
#= require ./routers/plans

@App =
  Models: {}
  Collections: {}
  Views: {} =
    Plans: {}
  Routers: {}
  Libs: {}

  init: ->
    new App.Routers.Plans()
    Backbone.history.start()
    loadingBox = new App.Views.LoadingBox()
    $(loadingBox.render().el).appendTo("body")

App.eventsDispatcher = _.clone(Backbone.Events)

$(document).ready ->
  App.init()
  window.location.hash = "/choose" if window.location.pathname == "/plans"
  window.location.hash = "#/dashboard" if window.location.pathname == "/" and window.location.hash == ""
  if window.location.pathname == "/subscription/new" or window.location.pathname == "/subscription/edit"
    $('ul.how_to a').click (e) ->
      content = $(e.target).attr('data-content')
      $('#modal').modal('show')
      $("#modal .modal-body p[data-content='#{content}']").show()
      $('#modal').on 'hide', (e) ->
        $("#modal .modal-body p[data-content='#{content}']").hide()
  return
