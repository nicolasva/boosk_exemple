App.Views.Wizards ||= {}

class App.Views.Wizards.Step3 extends Backbone.View
  template: JST["backend/templates/wizards/step_3"]

  form_id: '#wizard_step_3'

  events:
    "submit #wizard_step_3": "step_3"
    "click .back": "back"

  initialize: (options) ->
    @translate = options.translate.toJSON()
    @account = options.account
    @shop = @options.shop


  validate_emails: ->
    @shop.attributes.contact_attributes.emails_attributes = _.filter(@shop.attributes.contact_attributes.emails_attributes, (e) ->
      return !_.isEmpty(e.email)
    )

  step_3: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @validate_emails()
    @shop.attributes = {shop: @shop.attributes, shop_key: @shop.shop_key}
    App.eventsDispatcher.trigger 'startLoading'
    @shop.save @shop.attributes,
      wait: true
      success: (model, response)->
        App.eventsDispatcher.trigger 'loadingComplete'
        window.location.href = "/#/settings/wizard=true"
      error: (model, response)->
        App.eventsDispatcher.trigger 'loadingComplete'
        @model.set({errors: $.parseJSON(response.responseText)})

  back: ->
    $('.step-3').css('background-position', "0px -242px")
    $(".step-3-text").css('font-size', "0.8em")
    $(".step-3-text").css('color', "#b8beca")
    window.location.hash = '/w_step2'

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      shop: @shop.toJSON()
      account: @account.toJSON()
      translate: @translate
    }}))
    return this
