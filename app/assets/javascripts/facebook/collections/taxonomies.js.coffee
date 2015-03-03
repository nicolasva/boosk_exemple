class App.Collections.Taxonomies extends Backbone.Collection
  model: App.Taxonomy

  url: ->
    "/#{App.ui()}/shops/#{App.current_shop}/taxonomies"
