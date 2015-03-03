class App.Views.Popup extends Backbone.View

  template: JST["backend/templates/popup"]

  events:
    "click .actions .callback": "exec_callback"
    "click .actions .back": "close"


  initialize: (options) ->
    @message = options.message
    @translate = options.translate
    @mode = options.mode
    @callback = options.callback

    $('#modal').addClass('modal-confirm')
    $('#modal .modal-header').hide()
    $('#modal').on 'hide', (e) ->
      $('#modal').removeClass('modal-confirm')
      $('#modal .modal-header').show()
      $('.modal-backdrop').removeClass 'without-overlay'
    @render()

  exec_callback: (e) ->
    e.preventDefault()
    e.stopPropagation()
    if @callback != undefined
      @callback()
    $("#modal").modal('hide')
    @close()

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      message: @message
      translate: @translate
      mode: @mode
    } }))
    if @options.tpl != undefined
      $("#tpl").html(Haml.render(@options.tpl(), { locals: {
        translate: @translate
        object: @options.object
      } }))

    $('#modal').modal
      backdrop: 'static'
    $('#modal').modal('show')
    $('.modal-backdrop').addClass 'without-overlay'
    return @

  close: ->
    $(@el).unbind()
    $(@el).empty()
    @callback = null