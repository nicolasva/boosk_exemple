class App.Views.ShopSettings.FacebookTabManagement extends Backbone.View
  template: JST["backend/templates/shop_settings/facebook_tab_management"]

  events:
    "click #add-to-fan-page": "logFBUserAndFetchInformation"
    "change #fan_page_id": "changeFanPageID"

  initialize: (options) ->
    @shop = options.shop
    @account = App.account()
    @translate = options.translate
    @fan_pages = []
    @fan_page_id = @shop.get("fan_page_id") # we keep the fan_page_id value sent by the server
    @render()
    if App.fbSdkInit
      @fetchFBInformation()
    else
      App.eventsDispatcher.on "fbSdkInit", @fetchFBInformation, @

  render: ->
    if App.fbSdkInit
      @displayFBPreviewButton()
    else
      App.eventsDispatcher.on "fbSdkInit", @displayFBPreviewButton, @
    $(@el).html(Haml.render(@template(),
      locals:
        translate: @translate
        shop: @shop
        fan_pages: @fan_pages
    ))
    if @.$("#custom-tab").length
      @customTabView = new App.Views.ShopSettings.CustomTabManagement
        el: @.$("#custom-tab")
        translate: @translate
        shop: @shop
    if @shop.has('fan_page_id') and @shop.get('fan_page_id')
      $("#fan_page_id").val @shop.get('fan_page_id')
    return @

  fetchFBInformation: ->
    self = @
    FB.getLoginStatus (response) ->
      if response.status == "connected" 
        FB.api '/me/permissions', (response) ->
          if response.data[0].manage_pages
            FB.api '/me/accounts', (response) ->
              self.fan_pages = _.filter response.data, (page) ->
                page.category isnt "Application"
              self.render()

  logFBUserAndFetchInformation: (e) ->
    self = @
    e.stopPropagation()
    e.preventDefault()
    FB.login (response) ->
      data = {facebook_token: response.authResponse.accessToken}
      self.account.save {user: data},
        success: ->
          self.fetchFBInformation()
    ,
      scope: "user_about_me,email,publish_actions,manage_pages"

  changeFanPageID: ->
    @shop.set "fan_page_id", $("#fan_page_id option:selected").val()

  manageFacebookTab: (data) ->
    self = @
    #if fan_page_id value has changed (new page ID or empty value)
    if @shop.get("fan_page_id") isnt @fan_page_id
      new_page_id = @shop.get("fan_page_id")
      app_id = App.facebookAppId

      #if there is old fan_page_id, we try to delete old tab
      if @fan_page_id
        access_token = null
        _.each @fan_pages, (page) ->
          access_token = page.access_token if page.id is self.fan_page_id
        if access_token isnt null 
          FB.api "/#{self.fan_page_id}/tabs/app_#{App.facebookAppId}", "DELETE", {access_token: access_token}
      #now we can create new facebook tab
      if new_page_id isnt ""
        access_token = null
        _.each @fan_pages, (page) ->
          access_token = page.access_token if page.id is new_page_id
        if access_token isnt null
          FB.api "/#{new_page_id}/tabs", "POST", {app_id: app_id, access_token: access_token}, (response) ->
            if not response or response.error
              #we reset fan_page_id select with old value
              self.shop.set("fan_page_id", self.fan_page_id)  
              $("#fan_page_id").val(self.shop.get("fan_page_id"))
            else
              self.fan_page_id = self.shop.get("fan_page_id")
              self.manageCustomTab(data)
        else
          #we reset fan_page_id select with old value
          @shop.set("fan_page_id", @fan_page_id)
          $("#fan_page_id").val(@shop.get("fan_page_id"))
      else
        @fan_page_id = @shop.get("fan_page_id")        
    #if fan page id is already set and hasn't changed
    else if @shop.get("fan_page_id")
      @fan_page_id = @shop.get("fan_page_id")
      @manageCustomTab(data)

  manageCustomTab: (data) ->
    if data.custom_tab_name? or data.custom_tab_image_url
      access_token = null
      self = @
      _.each @fan_pages, (page) ->
        access_token = page.access_token if page.id is self.shop.get("fan_page_id")
      params = {access_token: access_token}
      if data.custom_tab_name?
        params.custom_name = data.custom_tab_name
        data.custom_tab_name.remove
      if data.custom_tab_image_url
        params.custom_image_url = data.custom_tab_image_url
        data.custom_tab_image_url.remove
      FB.api "/#{@shop.get("fan_page_id")}/tabs/app_#{App.facebookAppId}", "POST", params

  displayFBPreviewButton: () ->
    self = @
    @shop.fetch
      success: (model, response) =>
        if model.get("fan_page_id")
          FB.getLoginStatus (response) ->
            if response.status == "connected"
              FB.api "/#{model.get("fan_page_id")}/tabs/#{App.facebookAppId}", (response) ->
                if response.data and response.data[0] and response.data[0].link
                  $("#fb_preview").append $("<a href='#{response.data[0].link}' class='btn btn-primary' target='_blank'>#{self.translate.views.status.edit.fb_preview}</a>")
