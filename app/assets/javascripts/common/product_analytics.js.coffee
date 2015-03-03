window.ProductAnanalytics = class ProductAnanalytics extends Analytics

  constructor: (options = {}) ->
    super
    @options.chart.renderTo = options.container

  compare_by_action: (products, context) =>
    @options.chart.type = 'column'
    @options.xAxis =
      categories: _.map(@products_actions[context], (a) -> return a.name)
      labels:
        useHTML: true
        formatter: ->
          return "<span class=' picto #{@.value}'></span>"
  
    _.extend @options.legend, legend =
      padding: 15
      useHTML: true
      labelFormatter: ->
        src = $("#products_kpis tr[data-id='#{@options.product_uuid}']").find('img').attr('src')
        return "<img class='legend-product-thumb' src='#{src}'/><span style='color:#{@.color};' class='legend-product-label'>#{@.name}</span>"

    @options.yAxis =
      min: 0
      title:
        text: ''

    for product in products
      serie =
        name: product.product.name.capitalize()
        product_uuid: product.product.uuid
        data: []
        marker:
          symbol: 'circle'
  
      for action in @products_actions[context]
        data = _.find(product.kpis, (p) ->
          return p.value.action is action.name
        )
        data = if data? then data.value.count else 0
        serie.data.push(data)

      @set_series(serie)

    @build()
