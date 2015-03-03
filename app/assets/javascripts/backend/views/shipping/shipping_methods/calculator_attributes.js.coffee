App.Views.ShippingMethods ||= {}

class App.Views.ShippingMethods.CalculatorAttributes extends Backbone.View
  template: JST["backend/templates/shipping/methods/calculator_attributes"]

  initialize: (options) ->
    super(options)
    @calculator_types = options.calculator_types
    @translate = options.translate
    @model.on "change:calculator_type", @render, @
    @render()

  render: ->
    new_calc_type = @calculator_types.filter(
      (data) ->
        data.get('name') == @model.get('calculator_type')
      , @
    )[0] || @calculator_types.first()

    $(@el).html Haml.render(@template(), { locals: { calc_type: new_calc_type.toJSON(), translate: @translate } })
    calculator_attributes = @model.get('calculator_attributes')
    if calculator_attributes?
      for attr_name, attr_value of calculator_attributes
        @.$("#shipping_method_calculator_attributes_preferred_#{attr_name}").val(attr_value)
    return this
