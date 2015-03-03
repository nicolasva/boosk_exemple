class App.Views.ShopSettings.CustomTabManagement extends Backbone.View
  template: JST["backend/templates/shop_settings/custom_tab_management"]

  events:
    "click #custom_tab_name_link": "editCustomTabName"
    "blur #custom_tab_name": "updateCustomTabName"

  initialize: (options) ->
    @translate = options.translate
    @shop = options.shop
    @shop.on "change:fan_page_id", @render, @
    @render()

  render: ->
    self = @
    if @shop.get("fan_page_id")
      if @shop.hasChanged("fan_page_id")
        @finishRendering("/assets/fallback/tab_thumb_default.gif", "Boosket Shop")
      else
        FB.api "/#{@shop.get("fan_page_id")}/tabs/app_#{App.facebookAppId}", (response) ->
          if not response or response.error
            self.finishRendering("/assets/fallback/tab_thumb_default.gif", "Boosket Shop")
          else
            self.finishRendering(response.data[0].image_url, response.data[0].name)
    else
      $(@el).empty()
    return @

  finishRendering: (image_url, tab_name) ->
    $(@el).html(Haml.render(@template(),
      locals:
        translate: @translate
        image_url: image_url, 
        tab_name: tab_name
    ))
    new App.Libs.UploadPicture({
      browse_button: "custom_tab_image_link",
      resize:
        width: 111
        height: 74
        quality: 90
    }, (up, file, data) ->
      if not $("#custom_tab_image_url").length
        $("#custom_tab_image_link").append("<input type='hidden' name='custom_tab_image_url' id='custom_tab_image_url' />")
      $("#custom_tab_image_url").val(App.current_hostname + data.url)
      $("#custom_tab_image_link img").attr "src", data.url
    , "tab_thumbnail")

  editCustomTabName: (e) ->
    e.stopPropagation()
    e.preventDefault()
    $("#custom_tab_name_link").hide()
    if not $("#custom_tab_name").length
      $("#custom_tab_name_link").after("<input type='text' name='custom_tab_name' id='custom_tab_name' value='#{$("#custom_tab_name_link").text()}' />")
    $("#custom_tab_name").show()
    $("#custom_tab_name").focus()

  updateCustomTabName: ->
    $("#custom_tab_name").hide()
    $("#custom_tab_name_link").text($("#custom_tab_name").val() || "Boosket Shop")
    $("#custom_tab_name").val($("#custom_tab_name_link").text())
    $("#custom_tab_name_link").show()
