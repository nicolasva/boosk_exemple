class App.CommonViews.BoxResize.BoxResize extends Backbone.View
  initialize: (options) ->
    @el_box = options.el_box
    @width = options.width
    @height = options.height
    @background_color = options.background_color
    @color = options.color
    if options.padding_left
      @padding_left = options.padding_left
    else
      @padding_left = "0px"
    if options.padding_right
      @padding_right = options.padding_right
    else
      @padding_right = options.padding_right 
    if options.padding_bottom
      @padding_bottom = options.padding_bottom
    else
      @padding_bottom = "0px"
    if options.padding_bottom
      @padding_top = options.padding_bottom
    else
      @padding_top = "0px"
    if options.text_align
      @text_align = options.text_align
    else
      @text_align = "left"
    @render()

  render: ->
    $(@el_box).css("background-color", @background_color)
    $(@el_box).css("width", @width)
    $(@el_box).css("height", @height)
    $(@el_box).css("color", @color)
    $(@el_box).css("padding-left", @padding_left)
    $(@el_box).css("padding-right", @padding_right)
    $(@el_box).css("padding_bottom", @padding_bottom)
    $(@el_box).css("padding-top", @padding_top)
    $(@el_box).css("text-align", @text_align)
