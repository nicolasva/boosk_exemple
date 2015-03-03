App.Views.Zones ||= {}

class App.Views.Zones.Form extends Backbone.View
  template: JST["backend/templates/zones/form"]

  initialize: (options) ->
    super(options)
    @geographic_regions = options.geographic_regions
    @translate = options.translate
    @render()

  render: ->
    $(@el).html(Haml.render(@template(), { locals: { zone: @model.toJSON(), isNew : @model.isNew(), regions: @geographic_regions.toJSON(), translate: @translate} }))
    self = @
    $(".zones option").attr "selected", () ->
      "selected" if $(@).attr("value") in self.model.get("zone_members_codes")
    $(".region-select").select2
      minimumInputLength: 2
      formatNoMatches: (term) ->
        self.translate.views.select2.no_matches
      formatInputTooShort: (term, minLength) ->
        self.translate.views.select2.input_too_short.replace /%{nb}/, minLength - term.length
      matcher: (term, text) ->
        text.latinize().toUpperCase().indexOf(term.latinize().toUpperCase())>=0
    return @