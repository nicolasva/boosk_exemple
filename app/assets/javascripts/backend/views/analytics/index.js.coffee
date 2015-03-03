class App.Views.Analytics.Index extends Backbone.View
  el: '#app'

  template: JST["backend/templates/analytics/index"]
  template_product_kpis: JST["backend/templates/analytics/product_kpis_table"]
  template_top_products: JST["backend/templates/analytics/top_products"]
  
  events:
    "click .action": "change_action"
    "click .chart_type": "change_type"
    "click .product-selected": "show_products_action"
    "click .disabled-analytics + button": "upgrade_plan"
    "change #period" : "change_period"
    "submit #chart-by-range": "chart_by_range"
    "click #taxons ul.children-menu li": "select_category"
    "click #products_kpis #compare button": "compare_products"
    "click #products_kpis #show button": "display_products"
    "click #context #social,#revenue": "change_context"
    "click #top-products-by-action .menu span": "top_products_by_context"
    "click #top-products-by-action .content .name a": "show_product_stats"

  obj_type: 'shop'
  context: 'social'

  initialize: (options) ->
    @analytics = options.analytics
    @taxonomies = options.taxonomies
    @shop = options.shop.toJSON()
    @translate = options.translate.toJSON()
    @products = options.products
    @actions =
      0: { action: "shop", display: @translate.activerecord.models.shop.capitalize() }
      1: { action: "products", display: @translate.views.common.menu.products }
    @render()

  upgrade_plan: (e) ->
    e.preventDefault()
    e.stopPropagation()
    new App.Views.Plans.BoxUpgrade
      message: @translate.views.analytics.forbidden_plan

  show_products_action: (e) ->
    if $('#products_kpis .product-selected:checked').length >= 2
      $("#products_kpis #compare button").removeAttr('disabled')
      $("#products_kpis #show button").removeAttr('disabled')
    else if $('#products_kpis .product-selected:checked').length >= 1
      $("#products_kpis #compare button").attr('disabled','true')
      $("#products_kpis #show button").removeAttr('disabled')
    else if $('#products_kpis .product-selected:checked').length == 0
      $("#products_kpis #compare button").attr('disabled', 'true')
      $("#products_kpis #show button").attr('disabled', 'true')

  chart_by_range: (e) ->
    e.preventDefault()
    e.stopPropagation()
    unless @analytics.forbidden == true
      @analytics.from = $(e.target).find('.from').val()
      @analytics.to = $(e.target).find('.to').val()
      self = @
      App.eventsDispatcher.trigger 'startLoading'
      @analytics.fetch
        success: (attributes, models) ->
          self.graph.from = App.date_utc(self.analytics.from)
          self.graph.to = App.date_utc(self.analytics.to)
          self.graph.draw_chart(self.obj_type)
          App.eventsDispatcher.trigger 'loadingComplete'
        error: ->
          App.eventsDispatcher.trigger 'loadingComplete'

  change_context: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @context = $(e.currentTarget).attr('id')
    $("#context").find('.orange').removeClass('orange')
    $(e.currentTarget).addClass('orange')
    @graph.context = @context
    @graph.data = @analytics.toJSON()
    switch @obj_type
      when 'products'
        if $('#products_kpis .actions #compare[data-active=true]').length
          @compare_products()
        else
          @graph.draw_chart(@obj_type)
      when 'shop'
        @graph.draw_chart(@obj_type)  

  change_action: (e) ->
    @graph.data = @analytics.toJSON()
    object = $(e.currentTarget).attr('data-action')
    $("#chart-by-action li").removeClass('active')
    $(e.currentTarget).addClass('active')
    if object is "products"
      @products_focus()
    else if object is "shop"
      $('tr .product-selected').attr('checked', false)
      $('#products_kpis .actions button').attr('disabled', true)
      @shop_focus()
    @obj_type = object
    @graph.draw_chart(@obj_type)

  shop_focus: ->
    $("#top_products").show()
    $("#products_kpis").hide()
    $("#product-menu").hide()

  products_focus: ->
    $("#products_kpis").show()
    $("#top_products").hide()
    $("#product-menu").show()
  

  change_type: (e) ->
    @graph.draw_chart(@obj_type, $(e.target).val())

  compare_products: (e) ->
    if e?
      e.preventDefault()
      e.stopPropagation()
      $(e.currentTarget).parent().attr('data-active', 'true')

    products = []

    for p in $('#products_kpis .product-selected:checked')
      products.push _.find @analytics.get('products_kpis'), (pr) ->
        return $(p).parents("tr").attr('data-id') is pr.product.uuid
    
    pdt_analytics = new ProductAnanalytics
      container: 'graph'
    pdt_analytics.compare_by_action(products, @context)

  show_product_stats: (e) ->
    e.preventDefault()
    e.stopPropagation()
    $("#chart-by-action li[data-action='shop']").removeClass('active')
    $("#chart-by-action li[data-action='products']").addClass('active')
    @products_focus()
    $('tr .product-selected').attr('checked', false)
    $('#products_kpis #show button').removeAttr('disabled')
    $("tr[data-id=#{$(e.currentTarget).attr('data-id')}] .product-selected").attr('checked', true)
    @obj_type = 'products'
    @display_products()

  display_products: (e) ->
    if e?
      e.preventDefault()
      e.stopPropagation()
    $('#products_kpis #compare').removeAttr('data-active')
    products = []

    for p in $('#products_kpis .product-selected:checked')
      products.push _.find @analytics.get('products_kpis'), (pr) ->
        return $(p).parents("tr").attr('data-id') is pr.product.uuid
  
    self = @
    kpis = @analytics.get('products_kpis')
    analytics = new App.Analytic
    analytics.products_filter = _.map products, (p) -> return p.product.uuid
    analytics.fetch
      success: ->
        analytics.attributes.products_kpis = kpis
        analytics.products_filter = null
        self.graph.data = analytics.toJSON()
        self.graph.draw_chart(self.obj_type)
      error: ->
        analytics.products_filter = null

  change_period: (e) ->
    e.preventDefault()
    e.stopPropagation()
    unless @analytics.forbidden == true
      period = $(e.target).val()
      to_date = new Date(App.date_now_utc())
      switch period
        when "week" then from_date = new Date(App.days_ago_to_utc(6))
        when "month" then from_date = new Date(to_date.getFullYear(), to_date.getMonth(), 1)
        when "year" then from_date = new Date(to_date.getFullYear(), 0, 1)
        else from_date = to_date

      from_date_formatted = @formatDate(from_date)
      to_date_formatted = @formatDate(to_date)

      $(e.target).parent().find('.from').val(from_date_formatted)
      $(e.target).parent().find('.to').val(to_date_formatted)
      @analytics.from = from_date_formatted
      @analytics.to = to_date_formatted
      self = @
      App.eventsDispatcher.trigger 'startLoading'
      @analytics.fetch
        success: (attributes, models) ->
          self.graph.from = App.date_utc(App.to_en_date(self.analytics.from))
          self.graph.to = App.date_utc(App.to_en_date(self.analytics.to))
          self.graph.draw_chart(self.obj_type)
          App.eventsDispatcher.trigger 'loadingComplete'
        error: ->
          App.eventsDispatcher.trigger 'loadingComplete'


  top_products_by_context: (e) ->
    action = $(e.target).attr('data-action')
    $($(e.target).closest('.menu')[0]).find('.selected').removeClass('selected')
    $(e.target).addClass('selected')
    @.$("#top_products .content").html(Haml.render(@template_top_products(),
      locals:
        translate: @translate
        products: @products.toJSON()
        top_products: @analytics.get_top_products(action)
        action: action
        forbidden: @analytics.forbidden
    ))

  formatDate: (date) ->
    switch window.navigator.language
      when 'en'
        return "#{@pad(date.getMonth()+1)}/#{@pad(date.getDate())}/#{date.getFullYear()}"
      when 'fr'
        return "#{@pad(date.getDate())}/#{@pad(date.getMonth()+1)}/#{date.getFullYear()}"

  pad: (number) ->
    if number<10 then "0" + number else "#{number}"
  
  addChild: (item) ->
    $("#menu-root").children("ul.children-menu").append(new App.Views.ShopSettings.MenuItem(model: item).render().el)

  build_taxons: ->
    taxons = @taxonomies.first().taxons
    root = taxons.root()
    unless root.isLeaf()
      _.each root.children(), @addChild, @
    $.jstree._themes = '/assets/vendors/jstree/themes/'
    $("#taxons").jstree
      core:
        initially_open:[ "menu-root" ]
      themes:
        icons: false
      ui:
        select_limit: 1
        selected_parent_close: "deselect"
        select_prev_on_delete: false
        initially_select: [ "menu-root" ]
      types:
        max_depth: -2
        max_children: -2
        types:
          home:
            valid_children: "none"
            start_drag: false
            move_node: false
            delete_node: false
            remove: false
            select_node: false
          root:
            start_drag: false
            move_node: false
            delete_node: false
            remove: false
      plugins: [ "themes", "html_data", "ui", "crrm", "dnd", "types" ]

  select_category: (e) ->
    e.preventDefault()
    e.stopPropagation()
    id = $(e.currentTarget).attr('data-id')
    $("#taxons li a").removeClass('jstree-clicked') if $(e.currentTarget).attr('rel') is "home"
    @analytics.taxon_filter = id
    self = @
    @analytics.fetch
      success: ->
        self.graph.data = self.analytics.toJSON()
        self.graph.draw_chart(self.obj_type)
        self.$("#products_kpis").html(Haml.render(self.template_product_kpis(),
          locals:
            translate: self.translate
            products: self.products.toJSON()
            products_kpis: self.analytics.format_kpis()
        ))

  render: ->
    $(@el).html(Haml.render(@template(), {locals: {
      devise: @shop.devise
      actions : @actions
      translate: @translate
      forbidden: @analytics.forbidden
    } }))

    @.$("#products_kpis").html(Haml.render(@template_product_kpis(),
      locals:
        translate: @translate
        products: @products.toJSON()
        products_kpis: @analytics.format_kpis()
        forbidden: @analytics.forbidden
    ))

    @.$("#top_products .content").html(Haml.render(@template_top_products(),
      locals:
        translate: @translate
        products: @products.toJSON()
        top_products: @analytics.get_top_products(_.first(@analytics.m_kpis))
        action: _.first(@analytics.m_kpis)
        forbidden: @analytics.forbidden
    ))

    @build_taxons()

    $('.to').val(@formatDate(new Date(App.date_now_utc())))
    $('.from').val(@formatDate(new Date(App.days_ago_to_utc(6))))
    $("#chart-by-action li[data-action='shop']").addClass('active')
    $('.datepicker').datepicker($.datepicker.regional[window.navigator.language])

    @graph = new Analytics(@analytics.toJSON(), {
      container: 'graph'
    })

    @graph.draw_chart(@obj_type)
    return @
