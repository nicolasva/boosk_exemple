App.Views.Wizards ||= {}

class App.Views.Wizards.Step2 extends Backbone.View
  template: JST["backend/templates/wizards/step_2"]

  form_id: '#wizard_step_2'

  events:
    "submit #wizard_step_2": "step_2"
    "click .back": "step_2"
    "click .add-email": "add_email"
    "click .del-email": "delete_email"

  initialize: (options) ->
    @translate = options.translate.toJSON()
    @shop = @options.shop
    @account = @options.account

  step_2: (e) ->
    e.preventDefault()
    e.stopPropagation()
    data = $(@form_id).toJSON()
    self = @
    if _.extend(@shop.get('contact_attributes'), data.shop.contact_attributes)
      return self.back() if $(e.currentTarget).hasClass('back')
      $(".step-3").css("background-position", "0px -181px")
      $(".step-3-text").css('font-size', "1.1em")
      $(".step-3-text").css('color', "#fe6902")
      window.location.hash = '/w_step3'

  add_email: (e) ->
    clone_el = $(event.target).parent('.input-append').clone()
    button = $(clone_el).find('button')
    $(button).removeClass('add-email')
    $(button).addClass('del-email')
    $(button).html('x')
    $(clone_el).find('input').attr('value', '')
    $('.emails').append(clone_el)

  delete_email: (e) ->
    $(e.target).parent('.input-append').remove()

  back: ->
    $('.step-2').css('background-position', '0px -122px')
    $(".step-2-text").css('font-size', "0.8em")
    $(".step-2-text").css('color', "#b8beca")
    window.location.hash = '/w_step1'

  render: ->
    $(@el).html(Haml.render(@template(), { locals: { shop: @shop.toJSON(), account: @account.toJSON(), translate: @translate }}))
    $('.input-append').next().remove()
    return this
