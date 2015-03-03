class App.Collections.Taxons extends Backbone.Collection
  model: App.Taxon

  urlRoot:->
    @url

  root: ->
    unless @isEmpty()
      @chain().filter (taxon) ->
        taxon.isRoot()
      .first().value()

  comparator: (taxon) ->
    taxon.get('lft')
