App.Views.ShippingMethods ||= {}

class App.Views.ShippingMethods.Form extends Backbone.View
  template: JST["backend/templates/shipping/methods/form"]

  select_zone_id: '#shipping_method_zone_id'
  select_shipping_category_id: '#shipping_method_shipping_category_id'
  select_calculator_type: '#shipping_method_calculator_type'

  events:
    "change #shipping_method_calculator_type": "changeCalcType"

  initialize: (options) ->
    super(options)
    @zones = options.zones
    @zones.on "add", (zone) ->
      $("#shipping_method_zone_id").append new App.Views.SelectOption(value: zone.id, label: zone.get('name'), selected: false).render().el
    @translate = options.translate
    @calculator_types = new App.Collections.CalculatorTypes
    @render()

  changeCalcType: (e) ->
    @model.set 'calculator_type', $(e.target).val()

  fetch_zones: =>
    @zones.fetch
      success: (collection, response) =>
        select_zone = $(@select_zone_id)
        current_zone_id = @model.zone.get('id') ? null
        collection.each (zone) ->
          select_zone.append(new App.Views.SelectOption(
            value: zone.get('id'),
            label: zone.get('name'),
            selected: zone.get('id') is current_zone_id).render().el
          )


  render: ->
    $(@el).html(Haml.render(@template(model: @model), { locals: { shipping_method: @model.toJSON(), isNew : @model.isNew(), translate: @translate} }))
    @fetch_zones()
    self = @
    @calculator_types.fetch
      success: (collection, response) =>
        select_calculator_type = self.$(self.select_calculator_type)
        current_calculator_type = self.model.get('calculator_type')
        collection.each (calculator_type) ->
          select_calculator_type.append(new App.Views.SelectOption(value: calculator_type.get('name'), label: self.translate.activerecord.models["#{calculator_type.get('i18n_key')}"], selected: calculator_type.get('name') is current_calculator_type).el)
        new App.Views.ShippingMethods.CalculatorAttributes
          el: self.$('#calculator_attributes')
          model: self.model
          calculator_types: collection
          translate: self.translate
    return @