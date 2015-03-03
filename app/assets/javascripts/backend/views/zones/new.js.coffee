App.Views.Zones ||= {}

class App.Views.Zones.New extends Backbone.View
  template: JST["backend/templates/zones/new"]

  form_id: '#new_zone_form'

  events:
    "submit #new_zone_form": "save"

  initialize: (options) ->
    super(options)
    @geographic_regions = options.geographic_regions
    @model = new @collection.model()
    @translate = options.translate
    @render()

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    data = $(@form_id).toJSON()
    @collection.create(data.zone,
      success: (zone, response) =>
        App.eventsDispatcher.trigger 'loadingComplete'
        if self.options.modal == true
          $('#modal').modal('hide')
        else
          window.location.hash = "#/settings/zones"
      error: (zone, response) =>
        App.eventsDispatcher.trigger 'loadingComplete'
        errors = if response.status is 422 then $.parseJSON(response.responseText) else response
        new App.Views.Notice(message: errors, type: 'error', el: '#notice-modal' )
    )

  render: ->
    $(@el).html(Haml.render(@template(), { locals: { zone: @model.toJSON(), translate: @translate} }))
    new App.Views.Zones.Form
      el: @.$(@form_id)
      model: @model
      geographic_regions: @geographic_regions
      translate: @translate
    return @

  close: ->
    $(@el).empty()