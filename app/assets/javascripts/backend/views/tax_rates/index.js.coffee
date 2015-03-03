App.Views.TaxRates ||= {}

class App.Views.TaxRates.Index extends Backbone.View
  template: JST["backend/templates/tax_rates/index"]
  store_settings_menu: JST["backend/templates/shared/store_settings_menu"]
  support_block: JST["backend/templates/shared/support_block"]

  tagName: "section"
  id: "store-settings"
  className: "container-fluid"

  events:
    "click #new_tax_rate" : "new"
    "change .action": "perform_action"
    "click .select-all": "select_all"

  initialize: (options) ->
    @translate = options.translate.toJSON()
    @actions =
      0: { action: "destroy", display: @translate.delete.capitalize() }
    @zones = options.zones
    @tax_rates = options.collection
    @shop = options.shop
    @wizard = options.wizard
    @tax_rates.on "add", @taxRateAdded, @

  perform_action: (e) ->
    e.preventDefault()
    e.stopPropagation()
    perform = @actions[$(e.target).val()]
    if perform != undefined
      eval "this.#{perform['action']}()"
      $('.action option:first-child').attr('selected','selected')

  select_all: (e) ->
    $('.tax-selected').prop 'checked', $(e.target).is(':checked')

  taxRateAdded: (tax_rate) ->
    if $('.no-items').length != 0
      $('.no-items').remove()
      $('.action-taxe, .add, section.settings-content table').show()
    view = new App.Views.TaxRates.RowTable
      model: tax_rate
      zones: @zones
      translate: @translate
    @.$("table tbody").append(view.render().el)

  new: ->
    @view = new App.Views.TaxRates.New
      zones: @zones
      collection: @tax_rates
      translate: @translate
      modal: $('#modal')

    $('#modal').addClass('modal-tax-rates')
    $('#modal .modal-body').html(@view.render().el)
    $('#modal .modal-header h3').html @translate.views.tax_rate.add_tax
    $('#modal').modal('show')
    $(".chzn-select").chosen()
    self = @
    $('#modal').one 'hidden', (e) ->
      $('#modal').removeClass('modal-tax-rates')
      self.view.close()

  get_tax_rates_selected: (tax_rates) ->
    tax_rates_selected = []
    for tax_rate in tax_rates
      if $(tax_rate).is(':checked')
        id = $(tax_rate).parents('tr').attr('data-id')
        tax_rates_selected.push(@collection.get(id))
    return tax_rates_selected

  destroy: (event) ->
    tax_rates = @get_tax_rates_selected($('.tax-selected'))
    if _.isEmpty(tax_rates)
      @confirm = new App.Views.Popup
        translate: @translate
        message: @translate.views.tax_rate.no_tax_selected_warning
        el: $('#modal .modal-body')
        mode: "alert"
    else
      self = @
      @popup.close() if @popup != undefined
      @popup = new App.Views.Popup
        translate: @translate
        message: if tax_rates.length > 1 then @translate.views.tax_rate.remove_confirm.other else @translate.views.tax_rate.remove_confirm.one
        el: $('#modal .modal-body')
        mode: "confirm"
        callback: ->
          App.eventsDispatcher.trigger 'startLoading'
          self.collection.bulk_destroy tax_rates,
            wait: true
            success: (models, tax_rates) ->
              App.eventsDispatcher.trigger 'loadingComplete'
            error: ->
              App.eventsDispatcher.trigger 'loadingComplete'

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      actions: @actions
      translate: @translate
      has_tax_rates: !@tax_rates.isEmpty()
      wizard: @wizard
    } }))
    self = @
    @tax_rates.each (tax_rate) ->
      self.taxRateAdded(tax_rate)
    @.$("#store-settings-menu").html(Haml.render(@store_settings_menu(),
      locals:
        translate: @translate
        active: "tax_rates"
        has_active_payement: @shop.get('has_active_payement')
        wizard: @wizard
    ))
    @.$("#store-settings-menu").after(Haml.render(@support_block(),
      locals:
        translate: @translate
    ))
    return @
