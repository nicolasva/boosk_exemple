class App.Views.Promotions.ProductRowTable extends Backbone.View
  template: JST['backend/templates/promotions/product_row_table']

  tagName: 'tr'

  events:
    "click .product-selected" : "select"

  initialize: ->
    @translate = @options.translate

  render: ->
    $(@el).html(Haml.render(@template(), { locals: { model: @model} }))
    if @model.selected
      @.$('.product-selected').prop("checked", @model.selected)
    else if @model.get('promotions_overlaps')
      @.$('.product-selected').prop("disabled", true)
      @.$el.addClass("row-disabled").tooltip(title: @translate.views.promotion.promotion_overlap_warning)

    return @

  select: ->
    if @.$(".product-selected").is(':checked') then @trigger('select', @model) else @trigger('unselect', @model)
