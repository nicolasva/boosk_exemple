App.Views.ShopSettings ||= {}

class App.Views.ShopSettings.Status extends Backbone.View
  template: JST["backend/templates/shop_settings/status"]
  store_settings_menu: JST["backend/templates/shared/store_settings_menu"]
  support_block: JST["backend/templates/shared/support_block"]

  tagName: "section"
  id: "store-settings"
  className: "container-fluid"

  events:
    "click .back": "add_back_class"
    "submit form": "save"
    "click .status": "switch_on_off"

  initialize: (options) ->
    @translate = options.translate.toJSON()
    @shop = options.shop
    @customization = options.customization
    @sf = options.shop_functionnality.toJSON()
    @wizard = options.wizard
    @render()

  add_back_class: (e) ->
    $("#store-settings form").addClass("back-action")

  render: ->
    $(@el).html(Haml.render(@template(),
      locals:
        shop: @shop.toJSON()
        customization: @customization.toJSON()
        translate: @translate
    ))
    @.$("#store-settings-menu").html(Haml.render(@store_settings_menu(),
      locals:
        wizard: @wizard
        translate: @translate
        active: "status"
        has_active_payement: @shop.get('has_active_payement')
    ))
    @.$("#store-settings-menu").after(Haml.render(@support_block(),
      locals:
        translate: @translate
    ))
    @facebookTabView = new App.Views.ShopSettings.FacebookTabManagement
      el: @.$("#facebook-tab-management")
      shop: @shop
      translate: @translate
    $("#app").html(@el)
    $('#shop-preview').popover()

    return @

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()
    if @shop.get('has_active_payement')
      unless @sf.paypal_account and @sf.shipping_methods and @sf.taxes
        self = @
        @popup.close() if @popup != undefined
        $('#modal').addClass('modal-status')
        @popup = new App.Views.Popup
          translate: @translate
          message: @translate.views.status.cant_publish
          el: $('#modal .modal-body')
          tpl: JST["backend/templates/shop_settings/prerequisite_open_shop"]
          object: @sf
          mode: "alert"
        $('#need-for-open-shop ul li a').bind 'click', ->
          $('#modal').removeClass('modal-status')
          $('#modal').modal('hide')
        $('#modal').on 'hide', (e) ->
          $('#modal').removeClass('modal-status')
        return false
    data = $("form").toJSON()
    self = @
    App.eventsDispatcher.trigger 'startLoading'
    @facebookTabView.manageFacebookTab(data)
    @shop.set({facebook_page_token: $('#fan_page_id').find(":selected").attr('data-token-page')})
    @shop.save(data,
      success: (model, resp) ->
        App.eventsDispatcher.trigger 'loadingComplete'
        new App.Views.Notice(message: self.translate.views.shop.notice.updated_successfully, type: "success")
      error: (model, jqXHR) =>
        App.eventsDispatcher.trigger 'loadingComplete'
        new App.Views.Notice(message: self.translate.views.shop.error.update, type: "error")
      )

  close: ->
    $(@el).unbind()
    $(@el).empty()

  switch_on_off: (e) ->
    if @shop.get('has_active_payement')
      unless @sf.paypal_account and @sf.shipping_methods and @sf.taxes
        self = @
        @popup.close() if @popup != undefined
        $('#modal').addClass('modal-status')
        @popup = new App.Views.Popup
          translate: @translate
          message: @translate.views.status.cant_publish
          el: $('#modal .modal-body')
          tpl: JST["backend/templates/shop_settings/prerequisite_open_shop"]
          object: @sf
          mode: "alert"
        $('#need-for-open-shop ul li a').bind 'click', ->
          $('#modal').modal('hide')
          $('#modal').removeClass('modal-status')
        $('#modal').on 'hide', (e) ->
          $('#modal').removeClass('modal-status')
        return false
    status = 1
    if $(e.target).hasClass('small-on')
      $(e.target).removeClass('small-on')
      $(e.target).addClass('small-off')
      status = 0
    else
      $(e.target).removeClass('small-off')
      $(e.target).addClass('small-on')
    $(e.target).children().val(status)
