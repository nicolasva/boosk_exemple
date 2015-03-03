class App.Views.Shops.Index extends Backbone.View
  template: JST["backend/templates/shops/index"]
  account_settings_menu: JST["backend/templates/shared/account_settings_menu"]
  support_block: JST["backend/templates/shared/support_block"]

  tagName: "section"
  id: "account-settings"
  className: "container-fluid"

  events:
    "click .remove" : "destroy"
    "click .change-shop" : "change_shop"
    "click .edit" : "edit_shop"

  initialize: (options) ->
    @shops = options.shops
    @format_date()
    @translate = options.translate.toJSON()
    @render()

  change_shop: (e) ->
    id = $(event.target).parents('tr').attr('data-id')
    App.current_shop = id unless App.current_shop == id
    Backbone.history.navigate "#/dashboard", true

  edit_shop: (event) ->
    id = $(event.target).parents('tr').attr('data-id')
    unless App.current_shop == id
      App.current_shop = id
      $("#shop_selected_id").val(id).trigger("liszt:updated")
    Backbone.history.navigate "#/settings/wizard=false", true

  format_date: ->
    _.each @shops.models, (shop) ->
      shop.set(created_at: App.formatted_date(shop.get('created_at')))
      shop.set(updated_at: App.formatted_date(shop.get('updated_at')))

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      shops: @shops.toJSON()
      translate: @translate
    } }))
    @.$("#account-settings-menu").html(Haml.render(@account_settings_menu(),
      locals:
        translate: @translate
        active: "shops"
    ))
    @.$("#account-settings-menu").after(Haml.render(@.support_block(),
      locals:
        translate: @translate
    ))
    $("#app").html(@el)
    return @

  destroy: (event) ->
    self = @
    @popup.close() if @popup != undefined
    @popup = new App.Views.Popup
      translate: @translate
      message: @translate.views.shop.warning.remove_confirm
      el: $('#modal .modal-body')
      mode: "confirm"
      callback: ->
        shop_id = $(event.target).parents('tr').attr('data-id')
        shop = self.shops.get shop_id
        App.eventsDispatcher.trigger 'startLoading'
        shop.destroy
          success: (data, response) ->
            App.eventsDispatcher.trigger 'loadingComplete'
            $(event.target).parents("tr").hide 'slow', ->
              $(event.target).parents("tr").remove()
            if self.shops.models.length
              if App.current_shop == shop_id
                App.current_shop = self.shops.first().get('uuid')
                App.setCookie('shop_id', self.shops.first().get('uuid'))
                $("#shop_selected_id_chzn span:first").html(self.shops.first().get('name'))
            else
              window.location.hash = ""
              window.location.pathname = "/wizard"
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
