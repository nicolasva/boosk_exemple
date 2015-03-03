class App.Views.Shops.Edit extends Backbone.View
  template: JST["backend/templates/shops/edit"]
  store_settings_menu: JST["backend/templates/shared/store_settings_menu"]
  support_block: JST["backend/templates/shared/support_block"]

  className: "container-fluid"
  id: "store-settings"

  events:
    "submit form": "save"

  initialize: (options) ->
    @translate = options.translate.toJSON()
    @devises = options.devises
    @shop = options.model
    @wizard = options.wizard
    @render()

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      shop: @shop.toJSON()
      translate: @translate
      wizard: @wizard
      devises: @devises.toJSON()
    } }))
    @.$("#store-settings-menu").html(Haml.render(@store_settings_menu(),
      locals:
        translate: @translate
        active: "general"
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
    e.stopPropagation()
    e.preventDefault()
    data = $("form").toJSON()
    self = @
    App.eventsDispatcher.trigger 'startLoading'
    old_shop_mode = self.shop.get('has_active_payement')
    @shop.save(data,
      success: (model, resp) ->
        App.eventsDispatcher.trigger 'loadingComplete'
        if self.wizard
          Backbone.history.navigate("#/settings/menu", true)
        else
          new App.Views.Notice(message: self.translate.views.shop.notice.updated_successfully, type: "success")
          if old_shop_mode isnt self.shop.get('has_active_payement')
            self.$("#store-settings-menu").html(Haml.render(self.store_settings_menu(),
              locals:
                translate: self.translate
                active: "general"
                has_active_payement: self.shop.get('has_active_payement')
                wizard: self.wizard
            ))  
      error: (model, jqXHR) =>
        App.eventsDispatcher.trigger 'loadingComplete'
        new App.Views.Notice(message: self.translate.views.shop.error.update, type: "error")
    )
    return false

  close: ->
    $(@el).unbind()
    $(@el).empty()
