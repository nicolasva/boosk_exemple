App.Views.Products ||= {}

class App.Views.Products.TaxonomyOptGroup extends Backbone.View
  tagName: "optgroup"

  initialize: (options) ->
    self = @
    @collection.fetch
      success: ->
        self.render()

  render: ->
    $(@el).attr "label", @collection.root().get('name')
    $(@el).empty()
    self = @
    @collection.each (taxon) ->
      unless taxon.isRoot()
        $(self.el).append(new App.Views.SelectOption(label: "#{Array(taxon.level() + 1).join('-')} #{taxon.get('name')}", value: taxon.id, selected: taxon.id in self.model.get('taxon_ids')).el)
    return this