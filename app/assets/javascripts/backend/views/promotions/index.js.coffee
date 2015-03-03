class App.Views.Promotions.Index extends Backbone.View
  template: JST['backend/templates/promotions/index']

  tagName: "section"
  id: "promotions-index"
  className: "container-fluid"

  events:
    "click .select-all" : "selectAll"
    "click .add-promotion" : "add"
    "change .action": "performAction"

  initialize: ->
    @translate = @options.translate.toJSON()
    @actions =
      0: { action: "destroy", display: @translate.delete.capitalize() }
    @collection.on 'add', @promotionAdded, @
    @collection.on 'destroy', @checkCollection, @

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      translate: @translate
      actions: @actions
    } }))
    @collection.each @promotionAdded, @
    return @

  promotionAdded: (promotion) ->
    @.$('.no-items').hide()
    @.$('table').show()
    @.$('header .add-promotion').show()
    @.$('.action').show()
    view = new App.Views.Promotions.RowTable(model: promotion, translate: @translate)
    @.$("table tbody").append(view.render().el)

  selectAll: (e) ->
    self = @
    @collection.each (promotion) ->
      promotion.select($(e.target).is(':checked'))

  add: ->
    @view = new App.Views.Promotions.New
      collection: @collection
      translate: @translate
    @view.render()

  performAction: (e) ->
    e.preventDefault()
    e.stopPropagation()
    perform = @actions[$(e.target).val()]
    if perform != undefined
      eval "this.#{perform['action']}()"
      $('.action option:first-child').attr('selected','selected')

  destroy: ->
    if @collection.hasSelected()
      App.eventsDispatcher.trigger 'startLoading'
      self = @
      @collection.bulk_destroy @collection.selected(),
        wait: true
        success: (models, tax_rates) ->
          App.eventsDispatcher.trigger 'loadingComplete'
        error: ->
          App.eventsDispatcher.trigger 'loadingComplete'
    else
      new App.Views.Popup
        translate: @translate
        message: @translate.views.promotion.no_promotion_selected_warning
        el: $('#modal .modal-body')
        mode: "alert"

  checkCollection: ->
    if @collection.isEmpty()
      @.$('.no-items').show()
      @.$('table').hide()
      @.$('header .add-promotion').hide()
      @.$('.action').hide()
