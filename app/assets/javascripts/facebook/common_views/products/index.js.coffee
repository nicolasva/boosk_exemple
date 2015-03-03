class App.CommonViews.Products.Index extends Backbone.View

  initialize: (options) ->
    @last_page = options.next_page
    @translate = options.translate
    @el = options.el
    @template = options.template
    @products = options.products
    @products_grid = options.products_grid
    @render()

  render: ->
    if @last_page > 0 and @last_page is 999999999999
      $(@el).append(Haml.render(@template, {locals: {
        products: @products
        translate: @translate
        products_grid: @products_grid
      }}))
    else
      $(@el).html(Haml.render(@template, {locals: {
        products: @products
        translate: @translate
        products_grid: @products_grid
      }}))
    $(@el).attr("data-lastpage": @last_page)
    @options.context.loading = false
