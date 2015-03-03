class App.Views.Taxons.MenuItem extends Backbone.View
  template: JST["mobile/templates/menu/menu_item"]

  tagName: "li"
  
  tree_children: "ul.children-menu"
 
  events: 
    "click .taxon_img": "toggle_taxon_children"

  initialize: (options) ->
    @model = options.model
    @render()
  
  addChild: (item) -> 
    $(@el).children(@tree_children).append(new App.Views.Taxons.MenuItem(model: item).el)
   
  render: ->
    $(@el).html(Haml.render(@template(), {locals: {taxon: @model.toJSON()}}))

    unless @model.isLeaf()
      childrenEl = @make 'ul', {class: "children-menu"}
      $(@el).append childrenEl
      _.each @model.children(), @addChild, @
    else
      $(@el).find(".div_taxon_img").remove()
    return this

  toggle_taxon_children: (event) ->
    if($(event.target).hasClass("activate"))
      @hide_taxon_children(event)
    else
      @show_taxon_children(event)

  show_taxon_children: (event) ->
    $(event.target).parent().parent().parent().children().last().show()
    $(event.target).addClass("activate")
    return false

  hide_taxon_children: (event) ->
    $(event.target).parent().parent().parent().children().last().hide()
    $(event.target).removeClass("activate")
    return false
