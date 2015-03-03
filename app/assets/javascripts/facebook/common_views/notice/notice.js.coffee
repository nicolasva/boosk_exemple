class App.CommonViews.Notice.Notice extends Backbone.View
  template: JST["facebook/common_templates/notice/notice"]
 
  initialize: (options) ->
    @el = options.el
    @data = options.data
    @notice_style = options.notice_style
    @render()

  render: ->
    $(@el).html(Haml.render(@template(), {locals: { data: @data}}))
    @css_notice()
    $(@el).fadeToggle("linear") unless $(@el).is(':visible')
    $(@el).delay(3000).fadeToggle(2000, "linear")

  css_notice: ->
    $(@el).css("background-color", @notice_style.style.background_color)
    $(@el).css("color", @notice_style.style.color)
    $(@el).css("border", @notice_style.style.border)
    
