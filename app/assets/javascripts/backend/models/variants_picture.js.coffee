class App.VariantsPicture extends Backbone.Model

  initialize: (attributes) ->
    @cid = attributes.cached_path if attributes != undefined

  validate: (attributes) ->
    "Error!" unless attributes
