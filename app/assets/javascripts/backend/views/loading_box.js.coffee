class App.Views.LoadingBox extends Backbone.View
  template: ->
    template_name = 'backend/templates/loading_box'
    blank_template = -> ""

    return blank_template() if typeof JST is "undefined"
    for key of JST
      if key.indexOf(template_name) isnt -1
        return JST[key]()
    blank_template()

  id: "loading-box-wrapper"

  initialize: (options) ->
    App.eventsDispatcher.on 'startLoading', @show, @
    App.eventsDispatcher.on 'loadingComplete', @hide, @

  render: ->
    $(@el).hide()
    $(@el).html(Haml.render(@template()))
    return @

  show: ->
    $(@el).show()
    return @

  hide: ->
    $(@el).hide()
    return @
