class App.Views.Customizations.PictureView extends Backbone.View
  template: JST["backend/templates/customizations/_picture_view"]

  initialize: (options) ->
    @render()

  render: ->
    picture = @options.picture
    picture_type = @options.picture_type
    $(@el).html(Haml.render(@template(), { locals: { url: picture.url,  cached_path: picture.cached_name, picture_type: picture_type} }))
    return this