App.Views.ShopSettings ||= {}

class App.Views.ShopSettings.Menu extends Backbone.View
  template: JST["backend/templates/shop_settings/menu"]
  store_settings_menu: JST["backend/templates/shared/store_settings_menu"]
  support_block: JST["backend/templates/shared/support_block"]

  tagName: "section"
  id: "store-settings"
  className: "container-fluid"

  tree_children: "ul.children-menu"
  menu_container: "#menu-container"

  events:
    "click #add-item" : "addItem"
    "click #rename-item" : "renameItem"
    "click #destroy-item" : "destroyItem"
    "click #submit": "save"

  initialize: (options) ->
    @translate = options.translate.toJSON()
    @shop = options.shop
    @wizard = options.wizard
    super(options)
    _.bindAll @
    @render()

  addChild: (item) ->
    $("#menu-root").children(@tree_children).append(new App.Views.ShopSettings.MenuItem(model: item).render().el)

  addItem: ->
    $(@menu_container).jstree("create")

  renameItem: ->
    $(@menu_container).jstree("rename")

  destroyItem: ->
    $(@menu_container).jstree("remove")

  enableButtons: (e, data) ->
    $("#add-item").prop("disabled", false)
    if data.rslt.obj.attr("id") is "menu-root"
      $("#rename-item, #destroy-item").prop("disabled", true)
    else
      $("#rename-item, #destroy-item").prop("disabled", false)

  disableButtons: ->
    $("#rename-item, #add-item, #destroy-item").prop("disabled", true)

  createTaxon: (e, data) ->
    name = data.rslt.name
    position = data.rslt.position
    parent_id = if data.rslt.parent is -1 then @model.taxons.root().id else data.rslt.parent.attr("data-id")
    position-- if parent_id is @model.taxons.root().id
    @model.taxons.create { taxon: { name: name, parent_id: parent_id, position: position }},
      wait: true
      success: (model, response) ->
        $(data.rslt.obj).attr("data-id", model.id)
      error: ->
        $.jstree.rollback(data.rlbk)

  renameTaxon: (e, data) ->
    taxon = @model.taxons.get $(data.rslt.obj).attr("data-id")
    taxon.save {taxon: {name: data.rslt.new_name } },
      wait: true
      error: ->
        $.jstree.rollback(data.rlbk)

  destroyTaxon: (e, data) ->
    if data != undefined
      taxon = @model.taxons.get $(data.rslt.obj).attr("data-id")
      taxon.destroy
        wait: true
        error: ->
          data.inst.refresh()

  moveTaxon: (e, data) ->
    new_parent_id = (Number) $(data.rslt.np).attr("data-id")
    new_position = (Number) data.rslt.cp
    #Menu items can't be moved before Home item
    if isNaN new_parent_id
      $.jstree.rollback(data.rlbk)
    else
      if (new_position is 0) and (new_parent_id is @model.taxons.root().id)
        $.jstree.rollback(data.rlbk)
      else
        new_position-- if new_parent_id is @model.taxons.root().id
        taxon = @model.taxons.get $(data.rslt.o).attr("data-id")
        taxon.save {taxon: {parent_id: new_parent_id, position: new_position} },
          wait: true
          error: ->
            $.jstree.rollback(data.rlbk)

  save: (e) ->
    new App.Views.Notice(message: @translate.views.shop.notice.updated_successfully, type: "success")
    return false

  loadTutorialVideo: () ->
    tag = @make("script", {src: "//www.youtube.com/iframe_api"})
    $("script").first().before(tag)
    window.player
    window.onYouTubeIframeAPIReady = () ->
      window.player = new YT.Player('iframe-menu-help', {
        height: "360"
        width: "640"
        videoId: "REEpwmo9UNk"
      })

  render: ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    $(@el).html(Haml.render(@template(), { locals: {
      menu: @model.toJSON()
      translate: @translate
      wizard: @wizard
      has_active_payement: self.shop.get('has_active_payement')
    } }))
    @.$("#store-settings-menu").html(Haml.render(@store_settings_menu(),
      locals:
        translate: @translate
        active: "menu"
        has_active_payement: self.shop.get('has_active_payement')
        wizard: @wizard
    ))
    @.$("#store-settings-menu").after(Haml.render(@support_block(),
      locals:
        translate: @translate
    ))
    $("#app").html(@el)
    $('#shop-preview').popover()
    @model.taxons.fetch
      success: (collection, response) ->
        root = collection.root()
        $("#menu-root").attr("data-id", root.id)
        unless root.isLeaf()
          _.each root.children(), self.addChild, self
        $.jstree._themes = '/assets/vendors/jstree/themes/'
        $(self.menu_container).jstree
          core:
            initially_open:[ "menu-root" ]
          themes:
            theme: "boosket"
            icons: false
          ui:
            select_limit: 1
            selected_parent_close: "deselect"
            select_prev_on_delete: false
            initially_select: [ "menu-root" ]
          types:
            max_depth: -2
            max_children: -2
            types:
              home:
                valid_children: "none"
                start_drag: false
                move_node: false
                delete_node: false
                remove: false
                select_node: false
              root:
                start_drag: false
                move_node: false
                delete_node: false
                remove: false
          plugins: [ "themes", "html_data", "ui", "crrm", "dnd", "types" ]
        .on("create.jstree", self.createTaxon)
        .on("rename.jstree", self.renameTaxon)
        .on("remove.jstree", self.destroyTaxon)
        .on("select_node.jstree", self.enableButtons)
        .on("deselect_node.jstree", self.disableButtons)
        $("#menu-preview-container").html(new App.Views.ShopSettings.MenuPreview(taxons: collection, translate: self.translate).el)
        App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'
    @loadTutorialVideo()
    return @
