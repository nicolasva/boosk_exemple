class App.Taxon extends Backbone.Model
  defaults:
    name: ""

  validate: (attributes) ->
    "Error!" unless @attributes

  isLeaf: ->
    @right() - @left() == 1

  isRoot: ->
    not @has('parent_id')

  left: ->
    @get('lft')

  right: ->
    @get('rgt')

  setLeft: (lft) ->
    @set {lft: lft}, {silent: true}

  setRight: (rgt) ->
    @set {rgt: rgt}, {silent: true}

  children: ->
    if @id? and @collection?
      self = @
      @collection.filter (child) ->
        child.get('parent_id') == self.id
    else
      new Array

  parent: ->
    if @collection? and @has('parent_id')
      @collection.get(@get('parent_id'))
    else
      undefined

  descendants: ->
    if @id? and @collection?
      self = @
      @collection.filter (child) ->
        child.left() > self.left() and child.left() < self.right()
    else
      new Array

  level: ->
    self = @
    if @collection?
      ancestors = @collection.filter (taxon) -> 
        taxon.left() < self.left() and taxon.right() > self.right()
      ancestors.length
    else
      0

  moveToChildWithIndex: (node, index) ->
    if node.children().length == 1
      @moveToChildOf(node)
    else if node.children().length == index
      @moveToRightOf(node.children()[index-1])
    else
      @moveToLeftOf(node.children()[index])

  moveToChildOf: (node) ->
    @_moveTo node, "child"

  moveToRightOf: (node) ->
    @_moveTo node, "right"

  moveToLeftOf: (node) ->
    @_moveTo node, "left"

  _moveTo: (target, position) ->
    bound = switch position
      when "child" then target.right()
      when "left" then target.left()
      when "right" then target.right() + 1
      else -999

    return if bound == -999

    if bound > @.previous('rgt')
      bound = bound - 1
      other_bound = @.previous('rgt') + 1
    else
      other_bound = @.previous('lft') - 1

    # there would be no change
    return if bound is @.previous('rgt') or bound is @.previous('lft')

    # we have defined the boundaries of two non-overlapping intervals,
    # so sorting puts both the intervals and their boundaries in order
    [a, b, c, d] = _.sortBy [@.previous('lft'), @.previous('rgt'), bound, other_bound], (value) ->
      return value

    self = @
    @collection.each (taxon) ->
      if taxon is self
        #changes have already been made by server
      else if taxon.left() >= a and taxon.left() <= b
        taxon.setLeft(taxon.left() + d - b)
        taxon.setRight(taxon.right() + d - b)
      else if taxon.left() >= b and taxon.left <= d
        taxon.setLeft(taxon.left() + a - c)
        taxon.setRight(taxon.right() + a - c)
      else
        #no changes needed
