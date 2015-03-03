App.Views.TaxRates ||= {}

class App.Views.TaxRates.RowTable extends Backbone.View
  template: JST["backend/templates/tax_rates/row_table"]
  tagName: "tr"

  events:
    "click .edit" : "edit"

  initialize: (options) ->
    @zones = @options.zones
    @translate = @options.translate
    @model.on "change", @render, @
    @model.on "destroy", @hideAndRemove, @

  edit: (e)->
    e.preventDefault()
    e.stopPropagation()
    self = @

    @view = new App.Views.TaxRates.Edit
      model: @model
      zones: @zones
      translate: @translate
      modal: $('#modal')

    $('#modal').addClass('modal-tax-rates')
    $('#modal .modal-body').html(@view.render().el)
    $('#modal .modal-header h3').html @translate.views.tax_rate.edit_tax
    $('#modal').modal('show')
    $(".chzn-select").chosen()
    $('#modal').one 'hidden', (e) ->
      $('#modal').removeClass('modal-tax-rates')
      self.view.close()

  hideAndRemove: ->
    $(@el).fadeOut 500, =>
      @remove()

  render: ->
    $(@el).html(Haml.render(@template(), { locals: { tax_rate: @model.toJSON()} }))
    $(@el).attr "data-id", @model.id
    return @
