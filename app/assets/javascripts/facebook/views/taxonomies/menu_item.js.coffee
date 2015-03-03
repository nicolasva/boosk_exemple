class App.Views.Taxonomies.MenuItem extends Backbone.View
  template: JST["facebook/templates/taxonomies/menu_item"]

  tagName: "li"
  className: "taxon"

  tree_children: "ul.children-menu"

  addChild: (item) ->
    $(@el).children(@tree_children).append(new App.Views.Taxonomies.MenuItem(model: item).render().el)

  render: ->
    $(@el).attr "data-id", @model.id
    $(@el).html(Haml.render(@template(), { locals: { item: @model.toJSON()} }))
    unless @model.isLeaf()
      childrenEl = @make 'ul', {class: "children-menu"}
      $(@el).append childrenEl
      _.each @model.children(), @addChild, @
    return this
