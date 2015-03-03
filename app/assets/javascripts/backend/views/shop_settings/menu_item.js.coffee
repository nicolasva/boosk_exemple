App.Views.ShopSettings ||= {}

class App.Views.ShopSettings.MenuItem extends Backbone.View
  template: JST["backend/templates/shop_settings/menu_item"]

  tagName: "li"

  tree_children: "ul.children-menu"

  addChild: (item) ->
    $(@el).children(@tree_children).append(new App.Views.ShopSettings.MenuItem(model: item).render().el)

  render: ->
    $(@el).attr "data-id", @model.id
    $(@el).html(Haml.render(@template(), { locals: { item: @model.toJSON()} }))
    unless @model.isLeaf()
      childrenEl = @make 'ul', {class: "children-menu"}
      $(@el).append childrenEl
      _.each @model.children(), @addChild, @
    return this
