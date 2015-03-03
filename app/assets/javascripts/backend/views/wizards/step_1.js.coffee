App.Views.Wizards ||= {}

class App.Views.Wizards.Step1 extends Backbone.View
  template: JST["backend/templates/wizards/step_1"]

  form_id: '#wizard_step_1'

  events:
    "submit #wizard_step_1": "step_1"

  initialize: (options) ->
    @translate = options.translate.toJSON()
    @shop = @options.shop
    @devises = @options.devises
    @account = @options.account
    @geographic_regions = @options.geographic_regions

  step_1: (e) ->
    e.preventDefault()
    e.stopPropagation()
    data = $(@form_id).toJSON()
    @shop.shop_key = data.shop_key
    if @shop.set(data.shop)
      $(".step-2").css('background-position', "0px -60px")
      $(".step-2-text").css('font-size', "1.1em")
      $(".step-2-text").css('color', "#fe6902")
      window.location.hash = '/w_step2'

  render: ->
    # temp for keyade!
    k = App.getCookie('K_10520')
    u = App.getCookie('u')

    $(@el).html(Haml.render(@template(), { locals: {
      shop: @shop.toJSON()
      account: @account.toJSON()
      devises: @devises.toJSON()
      translate: @translate
      k: k
      u: u
    }}))
    self = @
    @geographic_regions.each (region) ->
      self.$('#shop_country').append new App.Views.SelectOption(value: region.get('name'), label: region.get('name'), selected: false).el
    @.$('#shop_country').select2
      minimumInputLength: 2
      allowClear: true
      formatNoMatches: (term) ->
        self.translate.views.select2.no_matches
      formatInputTooShort: (term, minLength) ->
        self.translate.views.select2.input_too_short.replace /%{nb}/, minLength - term.length
      matcher: (term, text) ->
        text.latinize().toUpperCase().indexOf(term.latinize().toUpperCase())>=0
    return @
