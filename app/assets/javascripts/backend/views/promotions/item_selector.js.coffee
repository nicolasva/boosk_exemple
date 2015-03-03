class App.Views.Promotions.ItemSelector extends Backbone.View
  template: JST['backend/templates/promotions/item_selector']
  pagination_template: JST['backend/templates/promotions/pagination']

  events:
    "submit form" : "updateSelectedProducts"
    "click a.next" : "nextPage"
    "click a.prev" : "previousPage"
    "click a.num" : "goToPage"

  initialize: ->
    @translate = @options.translate
    @collection.perPage = 5
    @collection.searchParams.promotionStart = @model.get('starts_at')
    @collection.searchParams.promotionEnd = @model.get('ends_at') if @model.get('ends_at')?
    @collection.on "reset", @refreshTable, @
    @rowViews = []
    @selectedProductIds = if @model.get("promotion_rules")? then @model.get("promotion_rules")[0].product_ids else []

  render: ->
    @.$el.html(Haml.render(@template(), { locals: { translate: @translate, model: @model } }))
    App.eventsDispatcher.trigger 'startLoading'
    @collection.fetch
      success: (collection) ->
        App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'
    return @

  refreshTable: ->
    view.remove() for view in @rowViews
    @rowViews = []
    self = @
    @collection.each (product) ->
      product.selected = self.selectedProductIds.contains(product.get('id'))
      view = new App.Views.Promotions.ProductRowTable(model: product, translate: self.translate)
      view.on 'select', self.productSelected, self
      view.on 'unselect', self.productUnselected, self
      self.rowViews.push view
      self.$("tbody").append(view.render().el)
    @refreshPagination()

  productSelected: (product) ->
    @selectedProductIds.push product.get('id')

  productUnselected: (product) ->
    @selectedProductIds.splice(@selectedProductIds.indexOf(product.get('id')), 1) unless @selectedProductIds.indexOf(product.get('id')) < 0

  updateSelectedProducts: ->
    oldAttributes = if @model.get("promotion_rules")? and @model.get("promotion_rules")[0]? then @model.get("promotion_rules")[0] else {}
    oldAttributes.product_ids = @selectedProductIds
    @model.set("promotion_rules_attributes", [oldAttributes])
    @model.set("promotion_rules", [oldAttributes])

  nextPage: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @collection.nextPage()

  previousPage: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @collection.previousPage()

  goToPage: (e) ->
    e.preventDefault()
    e.stopPropagation()
    page = $(e.target).text()
    @collection.atPage(page)

  refreshPagination: ->
    @.$("#paginate").html(Haml.render(@pagination_template(), { locals: { translate: @translate, collection: @collection } }))
