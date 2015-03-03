class App.Views.Shops.Preview extends Backbone.View
  template: JST["backend/templates/shops/preview"]

  tagName: "section"
  id: "store-preview"
  editAttachmentMode: false

  events:
    "click     #toggle-menu" : "toggleAttachmentMenu"
    "click     .move-attachment" : "moveAttachment"
    "click     .cancel-attachment-move" : "cancelAttachmentMove"
    "click     .save-attachment-move" : "saveAttachmentMove"
    "click     .edit-attachment-menu" : "stopPropagation"
    "click     .attachment-container" : "stopPropagation"
    "mousedown .attachment-container" :"stopPropagation"
    "mouseover .attachment-container" : "showMenuToggle"
    "mouseout  .attachment-container" : "hideMenuToggle"
    "mouseover .picture":  "show_opacity_button"
    "mouseout  .picture":  "hide_button"
    "mouseover .show":  "hide_opacity_button"
    "mousemove" : "updateMousePosition"

  initialize: (options) ->
    @customization = @options.customization
    @customization.on("change:background_color_shop", @changeBackgroundColorShop, @)
    @customization.on("change:background_color_product_list", @changeBackgroundColorProductList, @)
    @customization.on("change:background_color_product_thumb", @changeBackgroundColorProductThumb, @)
    @customization.on("change:background_color_sidebar", @changeBackgroundColorSidebar, @)
    @customization.on("change:background_color_sidebar_item", @changeBackgroundColorSidebarItem, @)
    @customization.on("change:color_text_product", @changeColorTextProduct, @)
    @customization.on("change:color_text_menu", @changeColorTextMenu, @)
    @customization.on("change:color_text_menu_hover", @changeColorTextMenuHover, @)
    @translate = @options.translate
    @products = new App.Collections.Products()
    @taxonomies = new App.Collections.Taxonomies()
    @render()

  showMenuToggle: (e) ->
    $("#toggle-menu").show() if not @editAttachmentMode

  hideMenuToggle: (e) ->
    $("#toggle-menu").hide() if $("#edit-header").is(':hidden')

  hide_button: (e) ->
    e.preventDefault()
    e.stopPropagation()
    unless $(e.relatedTarget).hasClass('show')
      $(e.target).parents('.picture').find('.show').hide()

  show_opacity_button: (e) ->
    e.preventDefault()
    e.stopPropagation()
    $(e.currentTarget).find('.show').removeClass('light-opacity')
    $(e.currentTarget).find('.show').addClass('light-opacity')
    $(e.currentTarget).find('.show').show()

  hide_opacity_button: (e) ->
    e.preventDefault()
    e.stopPropagation()
    $(e.target).removeClass('light-opacity')

  stopPropagation: (e) ->
    e.stopPropagation()

  cancelAttachmentMove: (e) ->
    e.preventDefault()
    e.stopPropagation()
    $(e.target).parents(".attachment-container").removeClass("edit-attachment-mode")
    $(e.target).parents(".attachment-container").children(".attachment-wrapper").off "mousedown"
    attachment_type = $(e.target).parents(".attachment-container").attr("rel")
    if @customization.has("#{attachment_type}_attributes")
      old_offset = @customization.get("#{attachment_type}_attributes").offset
    else
      old_offset = @customization.get("#{attachment_type}").offset
    $(e.target).parents(".attachment-container").children(".attachment-wrapper").children("img").css
      top: "#{old_offset}px"
    @editAttachmentMode = false

  saveAttachmentMove: (e) ->
    e.preventDefault()
    e.stopPropagation()
    $(e.target).parents(".attachment-container").removeClass("edit-attachment-mode")
    $(e.target).parents(".attachment-container").find(".attachment-wrapper").off "mousedown"
    #As the store preview is smaller than the real store front, we need here to calculate the real offset
    preview_offset = $(e.target).parents(".attachment-container").children(".attachment-wrapper").children("img").position().top
    preview_attachment_height = $(e.target).parents(".attachment-container").children(".attachment-wrapper").innerHeight()
    attachement_height = 250
    offset = preview_offset * attachement_height / preview_attachment_height
    attachment_type = $(e.target).parents(".attachment-container").attr("rel")
    @customization.updateAttachmentAttributes attachment_type, {offset: offset}
    @editAttachmentMode = false

  moveAttachment: (e) ->
    e.preventDefault()
    e.stopPropagation()
    $(e.target).parents(".attachment-container").find(".edit-attachment-menu").hide()
    $("#toggle-menu").hide()
    $(e.target).parents(".attachment-container").addClass("edit-attachment-mode")
    @editAttachmentMode = true
    $(e.target).parents(".attachment-container").find(".attachment-wrapper").on "mousedown", (e) ->
      mouseMoveStart = e.offsetY
      $(@).on "mousemove", (e) ->
        delta = e.offsetY - mouseMoveStart
        mouseMoveStart = e.offsetY
        actualPosition = $(@).children("img").position()
        $(@).children("img").css('top', "#{actualPosition.top + delta}px")
      .on "mouseup", () ->
        $(@).off "mousemove"
        $(@).off "mouseup"

  updateMousePosition: (e) ->
    @mousePositionY = e.pageY
    @mousePositionX = e.pageX

  toggleAttachmentMenu: (e) ->
    e.preventDefault()
    e.stopPropagation()
    if not @editAttachmentMode
      attachmentMenu = $(e.target).parents(".attachment-container").find(".edit-attachment-menu")
      if attachmentMenu.is(":visible")
        attachmentMenu.hide()
      else
        $(document).on 'mousedown', {menu: attachmentMenu}, @hideAttachmentMenu
        attachmentMenu.show()
        #Header edition
        self = @
        @uploadPictureHeader ?= new App.Libs.UploadPicture({
          browse_button: 'pickheader'
          container: 'edit-header'
          resize:
            width: 1024
            height: 1024
            quality: 90
        }, (up, file, data) ->
          $("#edit-header").hide()
          $("#header-wrapper").children("img").attr("src", data.url)
          $("#header-wrapper").children("img").css "top", 0
          self.customization.updateAttachmentAttributes(
            "header",
            {
              id : self.customization.get("header")["id"]
              cached_name : data.cached_name
              offset : 0
            })
        , "header", "#header-wrapper")

  hideAttachmentMenu: (e) ->
    if $(e.target).parents("##{e.data.menu.attr('id')}").length == 0
      e.data.menu.hide()
      $("#toggle-menu").hide()
      $(document).off 'mousedown', @hideAttachmentMenu

  changeBackgroundColorShop: ->
    $("#store-preview").css "background-color", @customization.get("background_color_shop")

  changeBackgroundColorProductList: ->
    $("#product_list").css "background-color", @customization.get("background_color_product_list")

  changeBackgroundColorProductThumb: ->
    $("#store-preview .product_thumb").css "background-color", @customization.get("background_color_product_thumb")

  changeBackgroundColorSidebar: ->
    $("#store-preview .menu-container").css "background-color", @customization.get("background_color_sidebar")

  changeBackgroundColorSidebarItem: ->
    $(".children-menu").css "background-color", @customization.get("background_color_sidebar_item")
    $("#store-preview .menu-container > li").off "hover"
    self = @
    $("#store-preview .menu-container > li").hover(
      () ->
        $(@).css "background-color", self.customization.get("background_color_sidebar_item")
        $(@).children("a").css "color", self.customization.get("color_text_menu_hover")
      () ->
        $(@).css "background-color", "transparent"
        $(@).children("a").css "color", self.customization.get("color_text_menu")
    )

  changeColorTextProduct: ->
    $("#store-preview .product_thumb .product_name .product_meta").css "color", @customization.get("color_text_product")

  changeColorTextMenu: ->
    $("#store-preview .menu-container .taxonomies_list > li > a").css "color", @customization.get("color_text_menu")
    $("#store-preview .menu-container #basket_shop .btn-group a.basket_button.dropdown-toggle").css "color", @customization.get("color_text_menu")

  changeColorTextMenuHover: ->
    $("#store-preview .menu-container #menu .taxonomies_list > li").off "hover"
    self =@
    $("#store-preview .menu-container #menu .taxonomies_list > li").hover(
      () ->
        $(@).children("a").css "color", self.customization.get("color_text_menu_hover")
        $(@).css "background-color", self.customization.get("background_color_sidebar_item")
      () ->
        $(@).children("a").css "color", self.customization.get("color_text_menu")
        $(@).css "background-color", "transparent"
    )

  render: ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @products.fetch
      success: (collection, response) ->
        if collection.isEmpty()
          for nb in [1..4]
            fake_product = new App.Product
              id: nb
              name: "Produit factice #{nb}"
              product_variants: [
                {
                  pictures: [
                    {
                      picture:
                        url: App.default_product_picture_url
                    }
                  ]
                  price: 999.99
                }
              ]
            collection.add fake_product
        $(self.el).html(Haml.render(self.template(),
          locals:
            products: collection.toJSON()
            customization: self.customization.toJSON()
            translate: self.translate
        ))
        $('.disabled-customization').css('height', "#{($('.disabled-customization').parent().height() + 300)}px") if self.customization.forbidden

        preview_height = $("#header-wrapper").innerHeight()
        preview_offset = self.customization.get('header').offset * preview_height / 250
        $("#header-wrapper").children("img").css "top", preview_offset
        #Store background color edition
        $("#store-preview").ColorPicker
          onShow: (colorpickr) ->
            unless $(colorpickr).children("h1").length > 0
              $(colorpickr).prepend(
                "<h1>#{self.translate.activerecord.attributes.customization.background_color_shop}</h1>")
            $(colorpickr).css
              top: "#{self.mousePositionY}px"
              left: "#{self.mousePositionX}px"
          onSubmit: (hsb, hex, rgb, el) ->
            $(el).ColorPickerHide()
            self.customization.set("background_color_shop", "#" + hex)
          onChange: (hsb, hex, rgb) ->
            $("#store-preview").css "background-color", "#" + hex
          onHide: (colorpickr) ->
            self.changeBackgroundColorShop()
          onBeforeShow: () ->
            $(@).ColorPickerSetColor(self.customization.get("background_color_shop").slice(1))
        #Products list background color edition
        $("#product_list").ColorPicker
          onShow: (colorpickr) ->
            unless $(colorpickr).children("h1").length > 0
              $(colorpickr).prepend(
                "<h1>#{self.translate.activerecord.attributes.customization.background_color_product_list}</h1>")
            $(colorpickr).css
              top: "#{self.mousePositionY}px"
              left: "#{self.mousePositionX}px"
          onSubmit: (hsb, hex, rgb, el) ->
            $(el).ColorPickerHide()
            self.customization.set("background_color_product_list", "#" + hex)
          onChange: (hsb, hex, rgb) ->
            $("#product_list").css "background-color", "#" + hex
          onHide: (colorpickr) ->
            self.changeBackgroundColorProductList()
          onBeforeShow: () ->
            $(@).ColorPickerSetColor(self.customization.get("background_color_product_list").slice(1))
        #Product thumb background color edition
        $(".product_thumb").ColorPicker
          onShow: (colorpickr) ->
            unless $(colorpickr).children("h1").length > 0
              $(colorpickr).prepend(
                "<h1>#{self.translate.activerecord.attributes.customization.background_color_product_thumb}</h1>")
            $(colorpickr).css
              top: "#{self.mousePositionY}px"
              left: "#{self.mousePositionX}px"
          onSubmit: (hsb, hex, rgb, el) ->
            self.customization.set("background_color_product_thumb", "#" + hex)
            $(el).ColorPickerHide()
          onChange: (hsb, hex, rgb) ->
            $("#store-preview .product_thumb").css "background-color", "#" + hex
          onHide: (colorpickr) ->
            self.changeBackgroundColorProductThumb()
          onBeforeShow: (hsb, hex, rgb, el) ->
            $(@).ColorPickerSetColor(self.customization.get("background_color_product_thumb").slice(1))
        #Product name color edition
        $(".product_thumb .product_meta .product_name").ColorPicker
          onShow: (colorpickr) ->
            unless $(colorpickr).children("h1").length > 0
              $(colorpickr).prepend(
                "<h1>#{self.translate.activerecord.attributes.customization.color_text_product}</h1>")
            $(colorpickr).css
              top: "#{self.mousePositionY}px"
              left: "#{self.mousePositionX}px"
          onSubmit: (hsb, hex, rgb, el) ->
            self.customization.set("color_text_product", "#" + hex)
            $(el).ColorPickerHide()
          onChange: (hsb, hex, rgb) ->
            $(".product_thumb .product_meta .product_name").css "color", "#" + hex
          onHide: (colorpickr) ->
            self.changeColorTextProduct()
          onBeforeShow: (hsb, hex, rgb, el) ->
            $(@).ColorPickerSetColor(self.customization.get("color_text_product").slice(1))
        #Sidebar background color edition
        $(".menu-container").ColorPicker
          onShow: (colorpickr) ->
            unless $(colorpickr).children("h1").length > 0
              $(colorpickr).prepend(
                "<h1>#{self.translate.activerecord.attributes.customization.background_color_sidebar}</h1>")
            $(colorpickr).css
              top: "#{self.mousePositionY}px"
              left: "#{self.mousePositionX}px"
          onSubmit: (hsb, hex, rgb, el) ->
            $(el).ColorPickerHide()
            self.customization.set("background_color_sidebar", "#" + hex)
          onChange: (hsb, hex, rgb) ->
            $("#store-preview .menu-container").css "background-color", "#" + hex
          onHide: (colorpickr) ->
            self.changeBackgroundColorSidebar()
          onBeforeShow: () ->
            $(@).ColorPickerSetColor(self.customization.get("background_color_sidebar").slice(1))
        self.taxonomies.fetch
          success: (taxonomies, response) ->
            taxonomies.first().taxons.fetch
              success: (taxons, response) ->
                $(".menu-container").html(new App.Views.ShopSettings.MenuPreview(taxons: taxons, translate: self.translate).el)
                #Sidebar item background color edition
                self.changeBackgroundColorSidebarItem()
                $(".menu-container li").ColorPicker
                  onShow: (colorpickr) ->
                    unless $(colorpickr).children("h1").length > 0
                      $(colorpickr).prepend(
                        "<h1>#{self.translate.activerecord.attributes.customization.background_color_sidebar_item}</h1>")
                    $(colorpickr).css
                      top: "#{self.mousePositionY}px"
                      left: "#{self.mousePositionX}px"
                  onSubmit: (hsb, hex, rgb, el) ->
                    $(el).ColorPickerHide()
                    self.customization.set("background_color_sidebar_item", "#" + hex)
                  onChange: (hsb, hex, rgb) ->
                    $(".children-menu").css "background-color", "#" + hex
                    $("#store-preview .menu-container li").hover(
                      () ->
                        $(@).css "background-color", "#" + hex
                      () ->
                        $(@).css "background-color", "transparent"
                    )
                  onHide: (colorpickr) ->
                    self.changeBackgroundColorSidebarItem()
                  onBeforeShow: () ->
                    $(@).ColorPickerSetColor(self.customization.get("background_color_sidebar_item").slice(1))
                #Menu color text edition
                self.changeColorTextMenu()
                $("#basket_shop a").ColorPicker
                  onShow: (colorpickr) ->
                    unless $(colorpickr).children("h1").length > 0
                      $(colorpickr).prepend(
                        "<h1>#{self.translate.activerecord.attributes.customization.color_text_menu}</h1>")
                    $(colorpickr).css
                      top: "#{self.mousePositionY}px"
                      left: "#{self.mousePositionX}px"
                  onSubmit: (hsb, hex, rgb, el) ->
                    self.customization.set("color_text_menu", "#" + hex)
                    $(el).ColorPickerHide()
                  onChange: (hsb, hex, rgb) ->
                    $(".menu-container .taxonomies_list > li > a").css "color", "#" + hex
                    $(".menu-container #basket_shop a").css "color", "#" + hex
                  onHide: (colorpickr) ->
                    self.changeColorTextMenu()
                  onBeforeShow: (hsb, hex, rgb, el) ->
                    $(@).ColorPickerSetColor(self.customization.get("color_text_menu").slice(1))
                #Menu color text hover edition
                self.changeColorTextMenuHover()
                $(".menu-container .taxonomies_list > li > a").ColorPicker
                  onShow: (colorpickr) ->
                    unless $(colorpickr).children("h1").length > 0
                      $(colorpickr).prepend(
                        "<h1>#{self.translate.activerecord.attributes.customization.color_text_menu_hover}</h1>")
                    $(colorpickr).css
                      top: "#{self.mousePositionY}px"
                      left: "#{self.mousePositionX}px"
                  onSubmit: (hsb, hex, rgb, el) ->
                    $(el).ColorPickerHide()
                    self.customization.set("color_text_menu_hover", "#" + hex)
                  onChange: (hsb, hex, rgb) ->
                    $(".menu-container .taxonomies_list > li").hover(
                      () ->
                        $(@).children("a").css "color", "#" + hex
                      () ->
                        $(@).children("a").css "color", self.customization.get("color_text_menu")
                    )
                  onHide: (colorpickr) ->
                    self.changeColorTextMenuHover()
                  onBeforeShow: (hsb, hex, rgb, el) ->
                    $(@).ColorPickerSetColor(self.customization.get("color_text_menu_hover").slice(1))

                App.eventsDispatcher.trigger 'loadingComplete'
              error: ->
                App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'
    return @
