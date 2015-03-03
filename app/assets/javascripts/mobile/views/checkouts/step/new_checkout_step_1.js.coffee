App.Views.Checkouts ||= {}
App.Views.Checkouts.New ||= {}

class App.Views.Checkouts.New.Step1 extends Backbone.View
  el: '#checkout'
  template: JST["mobile/templates/checkouts/step/new_step1"]

  id_form_step1: '#new_addresses'

  events:
    "submit #new_addresses" : "newStep1"
    "change #address_country" : "select_regions"

  initialize: (options) ->
    @translate = options.translate
    @contact = options.contact
    @carts = options.carts
    @geographic_regions = options.geographic_regions
    @render()

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {geographic_regions: @geographic_regions.toJSON(), translate: @translate.toJSON()}}))

  select_regions: (event) ->
    event.preventDefault()
    event.stopPropagation()
    value = $(event.target).attr("value")

    @match_shipping_method() unless value is "US"

    @country = _.find @geographic_regions.toJSON(), (r) ->
      return r.code == value

    if value is "US"
      $('#step-2').attr('disabled', 'disabled')
      @regions_view = new App.CommonViews.Checkouts.ChangeRegions
        regions: @country.subregions
        cart: @carts
      $('#regions').show()
    else
      $('#regions').hide()


  match_shipping_method: ->
    @carts.buyer_country = $('#address_country').attr('value')
    @carts.buyer_state = $('#address_states').attr('value')
    self = @
    @carts.fetch
      success: ->
        if self.carts.is_deliverable
          $('#step-2').removeAttr('disabled')
        else
          $('#step-2').attr('disabled', 'disabled')



  newStep1: (event) ->
    event.preventDefault()
    event.stopPropagation()
    data = $(@id_form_step1).toJSON()
    data.contact.addresses_attributes[0].country = @country.name
    if @contact.set(data.contact)
      window.location.hash = "/shops/checkouts/step2"
