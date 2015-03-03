window.Analytics = class Analytics extends Graph

  defaultPointStart: App.days_ago_to_utc(6)
  context: 'social'

  product_graph_options:
    social:
      tooltip:
        useHTML: false
      legend:
        useHTML: true
        borderColor: '#FFF'  
        labelFormatter: ->
          if @name.toLowerCase() is 'view'
            return @name
          else
            return "<span class='picto #{@name.toLowerCase()}'></span>"
    revenue:
      tooltip:
        useHTML: false
      legend:
        useHTML: false
        borderColor: '#FFF'
  
  shop_graph_options:
    social:
      tooltip:
        useHTML: false
      legend:
        useHTML: false
        borderColor: '#FFF'
    revenue:
      tooltip:
        useHTML: false
        #formatter: ->
        #  symbol = _.find(App.devises().models, (d) -> return d.get("iso") is App.getCookie('shop_devise')).get('symbol')
        #  return "#{@y} #{symbol}"
      legend:
        useHTML: false
        borderColor: '#FFF'

  products_actions:
    social:
      [
        {
          name: 'like'
          color: '#0066CC'
          type: 'Product'
        }
        {
          name: 'tweet'
          color: '#00CCFF'
          type: 'Product'
        }
        {
          name: 'want'
          color: '#CA7AFF'
          type: 'Product'
        }
        {
          name: 'have'
          color: '#00CC00'
          type: 'Product'
        }
        {
          name: 'pin'
          color: '#FF1A00'
          type: 'Product'
        }
      ]
    revenue:
      [
        {
          name: 'cart'
          color: '#00CC00'
          type: 'Product'
        }
        {
          name: 'order'
          color: '#FF1A00'
          type: 'Product'
        }
      ]

  shop_actions:
    social:
      [
        {
          name: 'view'
          color: '#f60'
          type: 'Shop'
        }
      ]
    revenue:
      [
        {
          name: 'income'
          color: '#FF1A00'
          type: 'Shop'    
        }
      ]

  constructor: (data, options = {}) ->
    super options
    @data = data
    @from = @defaultPointStart
    @to = null
    @type = 'spline'

  draw_chart: (obj, type = null) ->
    @serie = null
    @type = type if type?
    object = @get_object_type(obj)
    @reset_charts() unless @chart == undefined
    _.extend @options, object.graph_options
    cpt = 0
    switch @type
      when 'spline', 'column'
        if @type is 'spline'
          @options.tooltip.crosshairs = true
          @options.tooltip.shared = true
        for action in object['actions']
          @build_spline_or_column(object, action, cpt)
          cpt++
      when 'pie'
        @options.tooltip.crosshairs = false
        @options.tooltip.shared = false
        for action in object['actions']
          @build_pie(object, action)
    @build()

  build_spline_or_column: (object, action, index) ->
    @serie =
      name: action.name.capitalize()
      color: action.color or ''
      type: @type
      pointInterval: App.day_to_utc(1)
      pointStart: @from
      data: []
      marker:
        symbol: 'circle'

    range = if @to? then [0..App.nb_days_by_range(@from, @to)] else [6..0]

    for day in range
      date = if @to? then App.next_day_utc(@from, day) else App.days_ago_to_utc(day)
      match = false
      if object['data'] and object['data'][action.name]?
        for s in object['data'][action.name]
          if s.value.date == date
            @serie.data.push(s.value.count)
            match = true
            break
        @serie['yAxis'] = index unless index == 0 and object['data'][action.name].length > 1
      @serie.data.push(0) unless match

    yAxis = {
      min: 0
      max: object['max_yAxis']#if @context is 'revenue' then 1000 else 100
      gridLineWidth: 0
      allowDecimals: false
      title:
        text: '' #action.name.capitalize()
        style:
          color: action.color
      labels:
        enabled: false
        style:
          color: action.color
      plotLines: [{
        value: 0
        width: 1
        color: action.color
      }]
    }
    @set_yAxis(yAxis)
    @set_series(@serie)


  build_pie: (object, action) ->
    unless @serie?
      @serie =
        type: 'pie'
        name: action.type
        data: []
        marker:
          symbol: 'circle'

    unless @to?
      start = App.days_ago_to_utc(6)
      end = App.days_ago_to_utc(0)
    else
      start = @from
      end = @to

    i = 0
    if object['data'] and object['data'][action.name]?
      for s in object['data'][action.name]
        if start <= s.value.date and end >= s.value.date
          i += s.value.count
    @serie.data.push({name: action.name, y: i, color: action.color})

    @set_series(@serie) if action is _.last(object['actions'])

  reset_charts: ->
    @unset_series()
    @unset_yAxis()

  get_yAxis_max: (datas,actions) ->
    datas_filtered = {}
    dates = []
    range = if @to? then [0..App.nb_days_by_range(@from, @to)] else [6..0]
    for day in range
      dates.push if @to? then App.next_day_utc(@from, day) else App.days_ago_to_utc(day)
    for i,k of datas
      datas_filtered[i] = k if _.contains(actions,i)
    max = _.max(_.map(datas_filtered, (d) ->
      _.max(_.flatten(_.without(_.map(d,(f) -> return f.value.count if _.contains(dates,f.value.date)), undefined)))))
    return @suitable_yAxis(max)

  get_object_type: (object) ->
    switch object
      when 'products'
        max_yAxis = @get_yAxis_max(@data.products_charts, _.map(@products_actions[@context],(a) -> return a.name))
        return {data: @data.products_charts, actions: @products_actions[@context], graph_options: @product_graph_options[@context], max_yAxis: max_yAxis}
      when 'shop'
        if @context is 'social'
          data = _.extend @data.products_charts, @data.shop_charts
          actions = _.flatten [@shop_actions[@context], @products_actions[@context]]
          options = @product_graph_options[@context]
        else if @context is 'revenue'
          data = _.extend App.clone(@data.shop_charts), @data.category_charts
          cat_actions = _.map(@data.category_charts, (c) -> return {color: App.random_color(), name: c[0].value.category, type: 'Category'})
          if @type is 'pie'
            actions = cat_actions
            delete data.income
          else
            actions = _.flatten [@shop_actions[@context], cat_actions]
          options = @shop_graph_options[@context]
        max_yAxis = @get_yAxis_max(data, _.map(actions,(a) -> return a.name))  
        return {data: data, actions: actions, graph_options: options, max_yAxis: max_yAxis }
      else
        return false
