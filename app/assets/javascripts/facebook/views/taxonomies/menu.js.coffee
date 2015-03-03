class App.Views.Taxonomies.Menu extends Backbone.View
  template: JST["facebook/templates/taxonomies/menu"]
  tagName: "section"
  className: "clearfix"
  tree_children: ".taxonomies_list"

  "click #home": "track_ogp"

  initialize: (options) ->
    _.bindAll @
    @taxons = options.taxons
    @translate = options.translate
    @taxons.on "all", @render
    @render()

  addChild: (item) ->
    $(@el).find("#menu").children(@tree_children).append(new App.Views.Taxonomies.MenuItem(model: item).render().el)

  render: ->
    $(@el).html(Haml.render(@template(), { locals: { translate: @translate } }))
    if @taxons? and not @taxons.root().isLeaf()
      _.each @taxons.root().children(), @addChild, @
    return this
