App.Views.Payment ||= {}

class App.Views.Payment.Edit extends Backbone.View
  template: JST["backend/templates/payment/edit"]
  store_settings_menu: JST["backend/templates/shared/store_settings_menu"]
  support_block: JST["backend/templates/shared/support_block"]

  tagName: "section"
  id: "store-settings"
  className: "container-fluid"

  events:
    "click .back": "add_back_class"
    "submit form": "save"

  initialize: (options) ->
    @translate = options.translate.toJSON()
    @shop = options.model
    @account = options.account
    @wizard = options.wizard
    @render()

  add_back_class: (e) ->
    $("#store-settings form").addClass("back-action")

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      shop: @shop.toJSON()
      translate: @translate
      wizard: @wizard
      has_active_payement: @shop.get('has_active_payement')
    } }))
    @.$("#store-settings-menu").html(Haml.render(@store_settings_menu(),
      locals:
        translate: @translate
        active: "payment"
        has_active_payement: @shop.get('has_active_payement')
        wizard: @wizard
    ))
    @.$("#store-settings-menu").after(Haml.render(@support_block(),
      locals:
        translate: @translate
    ))
    $("#app").html(@el)
    $('#shop-preview').popover()
    return @

  save: (e) ->
    App.eventsDispatcher.trigger 'startLoading'
    data = $("form").toJSON()
    self = @
    @shop.save(data,
      success: (model, resp) ->
        App.eventsDispatcher.trigger 'loadingComplete'
        if self.wizard
          if $(e.currentTarget).hasClass('back-action')
            if !self.account.get('plan').has_customization
              window.location.hash = "/settings/shipping_methods"
            else
              window.location.hash = "/settings/customization"
          else
            window.location.hash = "/settings/option_types"
        else
          new App.Views.Notice(message: self.translate.views.payment.notice.updated_successfully, type: "success")

      error: (model, jqXHR) =>
        App.eventsDispatcher.trigger 'loadingComplete'
        new App.Views.Notice(message: jqXHR.responseText, type: "error")
    )
    return false
