class App.Collections.VariantsPictures extends Backbone.Collection
  model: App.VariantsPicture

  add_whithout_twice: (pictures) ->
    for picture in pictures
      @.add(picture) if @.getByCid(picture.cached_path) == undefined
