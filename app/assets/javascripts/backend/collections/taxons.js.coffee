class App.Collections.Taxons extends Backbone.Collection
  model: App.Taxon

  initialize: ->
    @on "add", @taxonAdded
    @on "remove", @destroyDescendants
    @on "change", @taxonChanged

  urlRoot:->
    @url

  root: ->
    unless @isEmpty()
      @chain().filter (taxon) ->
        taxon.isRoot()
      .first().value()

  comparator: (taxon) ->
    taxon.get('lft')

  taxonAdded: (newTaxon) ->
    if newTaxon.right()? and newTaxon.left()?
      @chain().filter (taxon) ->
        taxon isnt newTaxon and taxon.right() >= newTaxon.parent().right()
      .each (taxon) ->
        taxon.setRight(taxon.right() + 2)

      @chain().filter (taxon) ->
        taxon.left() > newTaxon.left()
      .each (taxon) ->
        taxon.setLeft(taxon.left() + 2)

  destroyDescendants: (removedTaxon) ->
    unless removedTaxon.isLeaf()
      self = @
      @chain().filter (taxon) ->
        taxon.left() > removedTaxon.left() and taxon.left() < removedTaxon.right()
      .each (taxon) ->
        self.remove taxon, {silent: true}
    #update lft and rgt for remaining nodes
    diff = removedTaxon.right() - removedTaxon.left() + 1
    @chain().filter (taxon) ->
      taxon.left() > removedTaxon.right()
    .each (taxon) ->
      taxon.setLeft(taxon.left() - diff)

    @chain().filter (taxon) ->
      taxon.right() > removedTaxon.right()
    .each (taxon) ->
      taxon.setRight(taxon.right() - diff)

  taxonChanged: (changedTaxon) ->
    new_parent = changedTaxon.parent()
    new_position = changedTaxon.get('position')
    changedTaxon.moveToChildWithIndex(new_parent, new_position)
    child_position = 0
    _.each new_parent.children(), (child) ->
      child.set {position: child_position}, {silent: true} unless child is changedTaxon
      child_position++