App.Views.TaxRates ||= {}

class App.Views.TaxRates.Edit extends Backbone.View
  template: JST["backend/templates/tax_rates/edit"]

  form_id: '#edit_tax_rate_form'

  events:
    "submit #edit_tax_rate_form": "update"

  initialize: (options) ->
    super(options)
    @translate = @options.translate
    @modal = @options.modal
    @model.bind("change:errors", () =>
      this.render()
    )
    @render()

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @model.save($(@form_id).toJSON().tax_rate,
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
      translate: @translate
    return @

  close: ->
    @undelegateEvents()
    @remove()
