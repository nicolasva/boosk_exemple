App.CommonViews.Checkouts ||= {}
App.CommonViews.Checkouts.New ||= {}

class App.CommonViews.Checkouts.ChangeRegions extends Backbone.View
  el: '#regions'
  template: JST["facebook/common_templates/checkouts/change_regions"]

  events:
    "change #address_states": "match_shipping_method"

  initialize: (options) ->
    @translate = new App.Translate
    @regions = options.regions
    @cart = options.cart
    self = @
    @translate.fetch
      success: ->
        self.render()


  match_shipping_method: (e) ->
    @cart.buyer_country = $('#address_country').attr('value')
    if @cart.buyer_country is "US"
      @cart.buyer_state = $('#address_states').attr('value')
      self = @
      @cart.fetch
        success: ->
          switch App.ui()
            when "facebook"
              if self.cart.is_deliverable
                $("#shipping").html("#{self.cart.shipping} #{App.getCookie('front_shop_devise')}")
                $("#total").html("#{self.cart.total_with_shipping} #{App.getCookie('front_shop_devise')}")
                $('#pay').removeAttr('disabled')
              else
                $("#shipping").html('--')
                $("#total").html("#{self.carts.total} #{App.getCookie('front_shop_devise')}")
                $('#pay').attr('disabled', 'disabled')
                $('#modal #notice .msg').html(self.translate.views.frontend.checkout.state_not_desserved)
                $('#notice').slideDown()
                setTimeout =>
                  $('#modal #notice').slideUp()
                  $('#modal #notice').find('.msg').html('')
                , 5000
            when "mobile"
              if self.cart.is_deliverable
                $('#step-2').removeAttr('disabled')
              else
                $('#step-2').attr('disabled', 'disabled')


  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      regions: @regions
      translate: @translate.toJSON()
    }}))
    $("#address_states").chosen() if $('body').attr("class") == 'facebook modal-open'
