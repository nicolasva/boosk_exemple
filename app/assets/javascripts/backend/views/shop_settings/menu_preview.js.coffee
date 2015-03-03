class App.Views.ShopSettings.MenuPreview extends Backbone.View
  template: JST["backend/templates/shop_settings/menu_preview"]
  tagName: "section"
  className: "clearfix"
  tree_children: ".taxonomies_list"

  initialize: (options) ->
    _.bindAll @
    @taxons = options.taxons
    @translate = @options.translate
    @taxons.on "all", @render
    @render()

  addChild: (item) ->
    $(@el).find("#menu").children(@tree_children).append(new App.Views.ShopSettings.MenuItem(model: item).render().el)

  render: ->
    $(@el).html(Haml.render(@template(), { locals: { translate: @translate } }))
    if @taxons? and not @taxons.root().isLeaf()
      _.each @taxons.root().children(), @addChild, @
    return this
