class App.Views.Checkout.Success extends Backbone.View
  el: '#modal'
  template: JST["facebook/templates/checkout/success"]

  events:
    "click #valid_order" : "close_modal"

  initialize: (options) ->
    @translate = options.translate.toJSON()
    @render()

  render: ->
    $(@el).addClass('modal-front-checkout')
    $(@el).addClass('modal-front-valid-order')
    $('#modal .modal-header h3').remove()
    $(@el).find($('#notice-modal')).remove()
    $(@el).find($('.modal-body')).html(Haml.render(@template(),{ locals: {
      translate: @translate
    } }))
    $(@el).modal('show')
    $('.modal-backdrop').addClass('white-overlay')
    $("#modal").on 'hide',(e) ->
      $(".modal-front-valid-order").removeClass("modal-front-valid-order")
      window.location.href = "#/shops/" + App.current_shop
    #clean all cart
    $.ajax
      url: "shops/"+App.current_shop+"/clean_carts"
      type: "DELETE"
      cache: false
      dataType: "script"

  close_modal: ->
    $("#modal").modal("hide")
