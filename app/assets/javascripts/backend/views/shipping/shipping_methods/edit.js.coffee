App.Views.ShippingMethods ||= {}

class App.Views.ShippingMethods.Edit extends Backbone.View
  template: JST["backend/templates/shipping/methods/edit"]

  form_id: '#edit_shipping_method_form'

  events:
    "submit #edit_shipping_method_form": "update"
    "click #add_zone": "showZoneForm"
    "submit #new_zone_form": "saveZone"
    "click #new_zone_form .back" : "showShippingMethodForm"

  initialize: (options) ->
    super(options)
    @translate = options.translate
    @zones = new App.Collections.Zones
    @geographic_regions = new App.Collections.GeographicRegions
    @render()

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @model.save($(@form_id).toJSON(),
      success: (shipping_method) =>
        App.eventsDispatcher.trigger 'loadingComplete'
        if self.options.modal == true
          $('#modal').modal('hide')
        else
          window.location.hash = "#/settings/shipping_methods"
      error: (shipping_method, jqXHR) =>
        App.eventsDispatcher.trigger 'loadingComplete'
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(Haml.render(@template(), { locals: { shipping_method: @model.toJSON(), translate: @translate } }))
    @form = new App.Views.ShippingMethods.Form
      el: @.$(@form_id)
      model: @model
      translate: @translate
      zones: @zones
    self = @
    App.eventsDispatcher.trigger 'startLoading'
    @geographic_regions.fetch
      success: (collection, response) ->
        new App.Views.Zones.Form
          el: self.$("#new_zone_form")
          model: new self.zones.model()
          geographic_regions: collection
          translate: self.options.translate
        App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'
    @delegateEvents()
    return @

  close: ->
    @undelegateEvents()
    $(@el).empty()

  showZoneForm: () ->
    self = @
    $("#edit_shipping_method_form").hide('fast', () ->
      $('#modal .modal-header h3').html(self.translate.views.zone.add_zone)
      $(".region-select").val("").trigger("change")
      $("#zone_name").val("")
      $("#new_zone_form").show('fast')
    )

  showShippingMethodForm: (e) ->
    self = @
    e.preventDefault()
    e.stopPropagation()
    $("#new_zone_form").hide('fast', () ->
      $("#edit_shipping_method_form").show('fast', () ->
        $('#modal .modal-header h3').html(self.translate.views.shipping_method.edit_shipping_method)
      )
    )

  saveZone: (e) ->
    e.preventDefault()
    e.stopPropagation()
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    data = $("#new_zone_form").toJSON()
    @zones.create(data.zone,
      wait: true
      success: (zone, response) =>
        App.eventsDispatcher.trigger 'loadingComplete'
        $("#new_zone_form").hide('fast', () ->
          $("#edit_shipping_method_form").show('fast')
        )
      error: (zone, response) =>
        App.eventsDispatcher.trigger 'loadingComplete'
        errors = if response.status is 422 then $.parseJSON(response.responseText) else response
        new App.Views.Notice(message: errors, type: 'error', el: '#notice-modal' )
    )
