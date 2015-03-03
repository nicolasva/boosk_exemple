class App.Views.Customizations.Edit extends Backbone.View
  template: JST["backend/templates/customizations/edit"]
  store_settings_menu: JST["backend/templates/shared/store_settings_menu"]
  support_block: JST["backend/templates/shared/support_block"]

  tagName: "section"
  id: "store-settings"
  className: "container-fluid"

  events:
    "click .back": "add_back_class"
    "submit #edit_shop_customization": "save"
    "click #edit_shop_customization :checkbox" : "toggleAttribute"
    "change .pick_color": "changeCustomizationAttribute"
    "change #nb_products_grid": "changeNbProductsGrid"
    "click .remove-attachment" : "removeAttachment"
    "click .disabled-customization + button": "upgrade_plan"

  initialize: (options) ->
    @translate = options.translate.toJSON()
    @shop = options.shop
    @customization = options.customization
    @wizard = options.wizard
    @render()


  add_back_class: (e) ->
    $("#store-settings form").addClass("back-action")

  upgrade_plan: (e) ->
    e.preventDefault()
    e.stopPropagation()
    new App.Views.Plans.BoxUpgrade
      message: @translate.views.customization.forbidden_plan

  changeCustomizationAttribute: (event) ->
    target = event.target
    change = {}
    change[target.name] = target.value
    @customization.set(change)

  removeAttachment: (event) ->
    event.preventDefault()
    event.stopPropagation()
    @customization.set "remove_#{$(event.target).parent().parent().attr('id')}", true
    $(event.target).parent().fadeOut () ->
      $(@).find("img").attr("src", "/assets/fallback/#{$(event.target).parent().parent().attr('id')}_default.jpg")
      $(@).show()

  render: ->
    App.eventsDispatcher.trigger 'startLoading'
    $(@el).html(Haml.render(@template(@customization.toJSON()),
      locals : 
        customization: @customization.toJSON()
        translate: @translate
        forbidden: @customization.forbidden
        has_active_payement: @shop.get('has_active_payement')
        wizard: @wizard
    ))
    @.$("#store-settings-menu").html(Haml.render(@store_settings_menu(),
      locals:
        translate: @translate
        active: "customization"
        has_active_payement: @shop.get('has_active_payement')
        wizard: @wizard
    ))
    @.$("#store-settings-menu").after(Haml.render(@support_block(),
      locals:
        translate: @translate
    ))
    $("#app").html(@el)
    $('#shop-preview').popover()

    $('.disabled-customization').css('height', $('.disabled-customization').parent().css('height')) if @customization.forbidden

    self = @
    new App.Views.Shops.Preview
      customization: @customization
      translate: @translate
      el: "#store-preview"
    new App.Libs.UploadPicture({
      browse_button: "pickteaser",
      container: "teaser",
      resize:
        width: 1024
        height: 1024
        quality: 90
    }, (up, file, data) ->
      self.customization.unset("remove_teaser")
      @view = new App.Views.Customizations.PictureView(picture: data, picture_type: "teaser", el: $("#teaser-container"))
    , "teaser", "#teaser")
    new App.Libs.UploadPicture({
      browse_button: "pickshutter",
      container: "shutter",
      resize:
        width: 1024
        height: 1024
        quality: 90
    }, (up, file, data) ->
      self.customization.unset("remove_shutter")
      @view = new App.Views.Customizations.PictureView(picture: data, picture_type: "shutter", el: $("#shutter-container"))
    , "shutter", "#shutter")

    return @

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    data = $("form#edit_shop_customization").toJSON()
    @customization.unset("header")
    @customization.unset("footer")
    @customization.save(data,
      success: (model, resp) ->
        App.eventsDispatcher.trigger 'loadingComplete'
        $('html, body').scrollTop(0)
        if self.wizard
          if $(e.currentTarget).hasClass('back-action')
            if self.shop.get('has_active_payement')
              window.location.hash = "/settings/shipping_methods"
            else
              window.location.hash = "/settings/menu"
          else
            if self.shop.get('has_active_payement')
              window.location.hash = "/settings/payment"
            else
              window.location.hash = "/settings/option_types"
        else
          new App.Views.Notice(message: self.translate.views.shop.notice.updated_successfully, type: "success")
      error: (model, jqXHR) =>
        Ap.eventsDispatcher.trigger 'loadingComplete'
        $('html, body').scrollTop(0)
        new App.Views.Notice(message: self.translate.views.shop.error.update, type: "error")
    )

  toggleAttribute: (e) ->
    $(e.target).next("[type=hidden]").val $(e.target).is(":checked")


  changeNbProductsGrid: (e) ->
    v = $(e.target).val()
    $('#product_list li.product_thumb').removeClassRegEx(/grid-*/)
    $('#product_list li.product_thumb').addClass("grid-#{v}")

  close: ->
    $(@el).unbind()
    $(@el).empty()
