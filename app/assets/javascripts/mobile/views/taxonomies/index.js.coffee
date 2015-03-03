class App.Views.Taxonomies.Index extends Backbone.View
  initialize: (options) ->
    @translate = options.translate
    @taxonomies = options.taxonomies 
    @render()

  render: ->
    @taxonomies.taxons.fetch
      success: (collection, response) ->
        root = collection.root() 
        @taxons = collection
        $(".taxon_lists").children().remove()
        if @taxons? and not @taxons.root().isLeaf()
          $.each(@taxons.root().children(), (key, val) ->
            $(".taxon_lists").append(new App.Views.Taxons.MenuItem(model: val).el)
          )
        
