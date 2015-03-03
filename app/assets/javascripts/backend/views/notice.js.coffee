class App.Views.Notice extends Backbone.View
  template: JST["backend/templates/notice"]

  displayLength: 5000
  el: "#notice"
  default_size: "small"

  initialize: (options) ->
    @message = options.message
    @type = options.type
    @el = options.el or @el
    @size = options.size or @default_size
    @displayLength = options.displayLength or @displayLength
    @render()

  render: ->
    $(@el).hide

    if Array.isArray @message
      if @message.length == 1
        $(@el).html(Haml.render(@template(), { locals: {
          message: @message
          type: @type
          mode: 'simple'
        } }))
      else
        $(@el).html(Haml.render(@template(), { locals: {
          message: @message
          type: @type
          mode: 'block'
        } }))
    else if typeof @message == 'string'
      $(@el).html(Haml.render(@template(), { locals: {
        message: @message
        type: @type
        mode: 'simple'
      } }))
    else
      complex_message = []
      for key of @message
        if Array.isArray @message[key]
          complex_message.push "#{key.capitalize()} #{item}" for item in @message[key]
        else
          complex_message.push "#{key.capitalize()} #{@message[key]}"
      $(@el).html(Haml.render(@template(), { locals: {
        message: complex_message
        type: @type
        mode: 'block'
      } }))
    switch @size
      when 'small'
        $(@el).removeClassRegEx(/span\-*/)
        $(@el).addClass('span9')
      when 'large'
        $(@el).removeClassRegEx(/span\-*/)
        $(@el).addClass('span12')
    $(@el).slideDown()
    self = @
    setTimeout =>
      $(@el).slideUp()
      $(@el).find('.alert').remove()
    , @displayLength
    return @
