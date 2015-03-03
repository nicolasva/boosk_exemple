App.Views.TaxRates ||= {}

class App.Views.TaxRates.New extends Backbone.View
  template: JST["backend/templates/tax_rates/new"]

  form_id: '#new_tax_rate_form'

  events:
    "submit #new_tax_rate_form": "save"

  initialize: (options) ->
    super(options)
    @modal = @options.modal
    @model = new @collection.model()
    @model.bind("change:errors", () =>
      this.render()
    )
    @render()

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @collection.create($(@form_id).toJSON().tax_rate,
      success: (tax_rate) =>
        App.eventsDispatcher.trigger 'loadingComplete'
        if $(self.modal).length > 0
          $(self.modal).modal('hide')
        else
          Backbone.history.navigate "#/settings/tax_rates", true
      error: (tax_rate, response) =>
        App.eventsDispatcher.trigger 'loadingComplete'
        errors = if response.status is 422 then $.parseJSON(response.responseText) else response
        new App.Views.Notice(message: errors, type: 'error', el: '#notice-modal' )
    )

  render: ->
    $(@el).html(Haml.render(@template(), { locals: { tax_rate: @model.toJSON()} }))
    new App.Views.TaxRates.Form
      el: @.$(@form_id)
      model: @model
      translate: @options.translate
    return @

  close: ->
    @undelegateEvents()
    @remove()