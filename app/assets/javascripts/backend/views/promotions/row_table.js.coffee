class App.Views.Promotions.RowTable extends Backbone.View
  template: JST['backend/templates/promotions/row_table']

  tagName: 'tr'

  events:
    'click .promotion-selected': 'select'
    'click .edit': 'edit'

  initialize: ->
    @translate = @options.translate
    @model.on 'change', @render, @
    @model.on 'destroy', @hideAndRemove, @

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      promotion: @model
    } }))
    @.$('.promotion-selected').prop 'checked', @model.isSelected()
    return @

  hideAndRemove: ->
    $(@el).fadeOut 500, =>
      @remove()

  edit: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @view = new App.Views.Promotions.Edit
      model: @model
      translate: @translate
    @view.render()

  select: (e) ->
    @model.select($(e.target).prop('checked'))
