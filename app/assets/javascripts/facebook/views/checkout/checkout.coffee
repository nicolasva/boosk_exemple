class App.Views.Checkout.Checkout extends Backbone.View
  el: '#modal'
  template: JST["facebook/templates/checkout/checkout"]

  events:
    "change #address_country" : "select_regions"
    "submit #new_addresses" : "create_order"

  initialize: (options) ->
    @address = options.address
    @geographic_regions = new App.Collections.GeographicRegions
    @carts = options.carts
    @translate = options.translate.toJSON()
    self = @
    @geographic_regions.fetch
      success: (geographic_regions) ->
        self.render()

  render: ->
    self = @
    $(@el).addClass('modal-front-checkout')
    $('#modal .modal-header h3').html((@translate.views.frontend.checkout.shipping_info).toUpperCase())
    $(@el).find($('#notice-modal')).hide()
    $(@el).find($('.modal-body')).html(Haml.render(@template(), { locals: {
      address: @address.toJSON()
      geographic_regions: @geographic_regions.toJSON()
      carts: @carts.toJSON()
      total: @carts.total
      translate: @translate
    }}))
    #$("#address_country").chosen()
    $("#address_country").select2
      minimumInputLength: 2
      formatNoMatches: (term) ->
        self.translate.views.select2.no_matches
      formatInputTooShort: (term, minLength) ->
        self.translate.views.select2.input_too_short.replace /%{nb}/, minLength - term.length
      matcher: (term, text) ->
        text.latinize().toUpperCase().indexOf(term.latinize().toUpperCase())>=0


    $(@el).modal('show')
    $('.modal-backdrop').addClass('white-overlay')
    $('.modal-body').addClass('span8')
    $('#modal .back').click -> $('#modal').modal('hide')
    $("#modal").on 'hide',(e) ->
      window.location.href = "#/shops/" + App.current_shop

  select_regions: (e) ->
    e.preventDefault()
    e.stopPropagation()
    value = $(e.target).attr("value")

    @match_shipping_method() unless value is "US"

    @country = _.find @geographic_regions.toJSON(), (r) ->
      return r.code == value

    if value is "US"
      $("#shipping").html('--')
      $("#total").html("#{@carts.total} #{App.getCookie('front_shop_devise')}")
      $('#pay').attr('disabled', 'disabled')
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
          $("#shipping").html("#{self.carts.shipping} #{App.getCookie('front_shop_devise')}")
          $("#total").html("#{self.carts.total_with_shipping} #{App.getCookie('front_shop_devise')}")
          $('#pay').removeAttr('disabled')
        else
          $("#shipping").html('--')
          $("#total").html("#{self.carts.total} #{App.getCookie('front_shop_devise')}")
          $('#pay').attr('disabled', 'disabled')
          $('#modal #notice .msg').html(self.translate.views.frontend.checkout.country_not_desserved)
          $('#notice').slideDown()
          setTimeout =>
            $('#modal #notice').slideUp()
            $('#modal #notice').find('.msg').html('')
          , 5000


  create_order: (e) ->
    e.preventDefault()
    e.stopPropagation()
    if $("#valid")[0].checked
      address = $("#new_addresses").toJSON()
      address.contact.addresses_attributes[0].country = @country.name
      if address.contact.addresses_attributes[0].state != undefined
        address.contact.addresses_attributes[0].state =  _.find(@country.subregions, (r) ->
          return r.code == address.contact.addresses_attributes[0].state
        ).name
      @order = new App.Order
      @order.save({contact: address.contact},
        success: (order, data) ->
          top.location.href = data.paypal_url
      )
