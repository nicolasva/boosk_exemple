class App.Taxonomy extends Backbone.Model
  defaults:
    name: ""

  initialize: (attributes) ->
    @taxons = new App.Collections.Taxons attributes.taxons
    @taxons.url = "/shops/#{App.current_shop}/taxonomies/#{@id}/taxons"

  validate: (attributes) ->
    "Error!" unless attributes
