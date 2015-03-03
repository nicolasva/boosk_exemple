App.Views.Checkouts ||= {}
App.Views.Checkouts.New ||= {}

class App.Views.Checkouts.New.Step2 extends Backbone.View
  el: "#checkout"
  template: JST["mobile/templates/checkouts/step/new_step2"]
  id_form_accept_reglement: "#accept_reglement"

  events:
    "submit #accept_reglement" : "submit_order"
    "click .roles": "checked_conditions"
    "click #accepts": "checkbox_accept"
    "click #cancel": "cancel"

  initialize: (options) ->
    @translate = options.translate
    @carts = options.carts
    @contact = options.contact
    @render()

  render: ->
    @contact = @contact.toJSON()
    $(@el).html(Haml.render(@template(), { locals: {
      carts: @carts.toJSON()
      total: @carts.total_with_shipping
      shipping: @carts.shipping
      contact: @contact
      address: @contact.addresses_attributes[0]
      email: @contact.emails_attributes[0].email
      translate: @translate.toJSON()
    }}))

  save: ->
    @order = new App.Order
    @order.save({contact: @contact},
      success: (order, data) ->
        window.location = data.paypal_url
    )

  submit_order: (event) ->
    event.preventDefault()
    event.stopPropagation()
    data = $(@id_form_accept_reglement).toJSON()
    unless _.isUndefined(data.law)
      @save()
    else
      @ViewCheckoutsNewNoAcceptsLaw = new App.Views.Checkouts.Step2.NoAcceptLaw(translate: @translate)
    return false

  checked_conditions: (event) ->
    if $("#accepts").is(':checked')
      $("#accepts").attr('checked', false)
      @button_submit_order(false)
    else
      $("#accepts").attr('checked',true)
      @button_submit_order(true)

  checkbox_accept: (event) ->
    if _.isUndefined($(event.target).attr('checked'))
      @button_submit_order(false)
    else
      @button_submit_order(true)

  cancel: (event) ->
    window.location.hash = "#/shops/"+App.current_shop

  button_submit_order: (status) ->
    if status == false
      $("#submit").attr("class", "btn btn-warning")
      $("#submit").attr("disabled", "disabled")
    else
      $("#submit").attr("class", "orange")
      $("#submit").removeAttr("disabled")
