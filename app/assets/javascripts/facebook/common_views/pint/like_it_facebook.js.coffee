class App.CommonViews.Pint.LikeItFacebook extends Backbone.View
  template: JST["facebook/common_templates/pint/facebook/like_it"]
  el: '#boxproductvariant'

  initialize: (options) ->
    @location = options.location
    @render()

  render: ->
    window.open(Haml.render(@template(), {locals: {location: @location}}),"Like", "menubar=no, status=no, scrollbars=no, menubar=no, width=600, height=250")
