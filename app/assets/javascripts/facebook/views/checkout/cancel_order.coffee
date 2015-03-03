class App.Views.Checkout.CancelOrder extends Backbone.View
  el: '#modal'
  template: JST["facebook/templates/checkout/cancel_order"]

  events:
    "click #valid_order" : "close_modal"

  initialize: (options) ->
    @render()

  render: ->
    $(@el).addClass('modal-front-checkout')
    $(@el).addClass('modal-front-valid-order')
    $('#modal .modal-header h3').remove()
    $(@el).find($('#notice-modal')).remove()
    $(@el).find($('.modal-body')).html(Haml.render(@template()))

    $(@el).modal('show')
    $('.modal-backdrop').addClass('white-overlay')

    $("#modal").on 'hide',(e) ->
      $(".modal-front-valid-order").removeClass("modal-front-valid-order")
      window.location.href = "#/shops/" + App.current_shop

  close_modal: ->
    $("#modal").modal("hide")
