class App.Views.Administrators.New extends Backbone.View
  template: JST["backend/templates/administrators/new"]

  line_template: JST["backend/templates/administrators/administrator_line"]

  form_id: '#new_administrator_form'

  events:
    "submit #new_administrator_form": "save"

  initialize: (options) ->
    @administrators = options.administrators
    @translate = options.translate
    @account = options.account

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @administrators.create($(@form_id).toJSON(),
      wait: true,
      success: (model, administrator) =>
        App.eventsDispatcher.trigger 'loadingComplete'
        $("#modal").modal('hide')
        $('.no-items').hide()
        $('#administrators table').show()
        $('#administrators .menu-items').show()
        $('#administrators table tbody').append(
          Haml.render(self.line_template(), { locals: {
            administrator: model.toJSON()
            translate: self.translate
          }}))
        $('#administrators table tbody tr:last-child').fadeIn(800)  
      error: (administrator, errors) =>
        App.eventsDispatcher.trigger 'loadingComplete'
    )

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      translate: @translate
    } }))
    return @
