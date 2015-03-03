App.Views.Zones ||= {}

class App.Views.Zones.Index extends Backbone.View
  template: JST["backend/templates/zones/index"]
  store_settings_menu: JST["backend/templates/shared/store_settings_menu"]
  support_block: JST["backend/templates/shared/support_block"]

  tagName: "section"
  id: "store-settings"
  className: "container-fluid"

  events:
   "click .destroy" : "destroy"
   "click #new_zone" : "new"
   "click .edit-zone" : "editZone"
   "change .action": "perform_action"
   "click .select-all": "select_all"

  initialize: (options) ->
    @translate = options.translate
    @shop = options.shop
    @wizard = options.wizard
    @actions =
      0: { action: "destroy", display: @translate.delete.capitalize() }
    self = @
    @geographic_regions = new App.Collections.GeographicRegions
    @collection.on 'reset', ->
      self.render()

  perform_action: (e) ->
    e.preventDefault()
    e.stopPropagation()
    perform = @actions[$(e.target).val()]
    if perform != undefined
      eval "this.#{perform['action']}()"
      $('.action option:first-child').attr('selected','selected')

  select_all: (e) ->
    $('.zone-selected').attr 'checked', $(e.target).is(':checked')

  get_zones_selected: (zones) ->
    zones_selected = []
    for zone in zones
      if $(zone).is(':checked')
        id = $(zone).parents('tr').attr('data-id')
        zones_selected.push(@collection.get(id))
    return zones_selected


  destroy: (event) ->
    zones = @get_zones_selected($('.zone-selected'))
    if _.isEmpty(zones)
      @confirm = new App.Views.Popup
        translate: @translate
        message: @translate.views.zone.no_zone_selected_warning
        el: $('#modal .modal-body')
        mode: "alert"
    else
      self = @
      @popup.close() if @popup != undefined
      @popup = new App.Views.Popup
        translate: @translate
        message: if zones.length > 1 then @translate.views.zone.remove_confirm.other else @translate.views.zone.remove_confirm.one
        el: $('#modal .modal-body')
        mode: "confirm"
        callback: ->
          App.eventsDispatcher.trigger 'startLoading'
          self.collection.bulk_destroy zones,
            success: (models, zones) ->
              App.eventsDispatcher.trigger 'loadingComplete'
              for zone in zones
                self.collection.remove self.collection.get(zone.id)
                $("tr[data-id=#{zone.id}]").fadeOut 500, ->
                  $("tr[data-id=#{zone.id}]").remove()
            error: ->
              App.eventsDispatcher.trigger 'loadingComplete'

  new: (e) ->
    e.preventDefault()
    e.stopPropagation()
    App.eventsDispatcher.trigger 'startLoading'
    view = @
    @geographic_regions.fetch
      success: (geographic_regions) ->
        @modal = new App.Views.Zones.New
          collection: view.collection
          geographic_regions: geographic_regions
          el: $('#modal .modal-body')
          translate: view.translate
          modal: true
        $('#modal').addClass('modal-zones')
        $('#modal .modal-header h3').html(view.translate.views.zone.add_zone)
        $('#modal').modal('show')
        self = @
        $('#modal').one 'hidden', (e) ->
          view.collection.fetch()
          self.modal.close()
          $('#modal').removeClass('modal-zones')
        App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  editZone: (e) ->
    e.preventDefault()
    e.stopPropagation()
    App.eventsDispatcher.trigger 'startLoading'
    id = $(e.target).parents('tr').attr('data-id')
    zone_el = $(e.target).parents('tr')
    zone = @collection.get(id)
    view = @
    @geographic_regions.fetch
      success: (geographic_regions) ->
        @modal = new App.Views.Zones.Edit
          translate: view.translate
          geographic_regions: geographic_regions
          model: zone
          el: $('#modal .modal-body')
          modal: true

        $('#modal').addClass('modal-zones')
        $('#modal .modal-header h3').html(view.translate.views.zone.edit_zone)
        $('#modal').modal('show')
        self = @
        $('#modal').on 'hidden', (e) ->
          view.collection.fetch()
          $('#modal').removeClass('modal-zones')
          self.modal.close()
        App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      zones: @collection.toJSON()
      actions: @actions
      translate: @translate
    } }))
    @.$("#store-settings-menu").html(Haml.render(@store_settings_menu(),
      locals:
        translate: @translate
        active: "zones"
        has_active_payement: @shop.get('has_active_payement')
        wizard: @wizard
    ))
    @.$("#store-settings-menu").after(Haml.render(@support_block(),
      locals:
        translate: @translate
    ))
    return this
