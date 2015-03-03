App.Views.TaxRates ||= {}

class App.Views.TaxRates.Form extends Backbone.View
  template: JST["backend/templates/tax_rates/form"]

  initialize: (options) ->
    super(options)
    @render()

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      tax_rate: @model.toJSON(),
      isNew : @model.isNew(),
      translate: @options.translate
    } }))
    return @
