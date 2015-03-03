class App.Collections.Taxonomies extends Backbone.Collection
  model: App.Taxonomy

  url: ->
    "/shops/#{App.current_shop}/taxonomies"
