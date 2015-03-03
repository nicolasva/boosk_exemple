window.Graph = class Graph
  constructor: (options) ->
    @series = []
    @options =
      global:
        useUTC: false
      credits:
        enabled: false
      chart:
        renderTo: options.container
        zoomType: 'xy'
        defaultSeriesType: options.defaultSeriesType or 'spline'
        events: null
      title:
        text: options.title or ''
      xAxis:
        type: options.xAxis_type or "datetime"
      plotOptions:
        pie:
          allowPointSelect: true
          cursor: 'pointer'
          dataLabels:
            enabled: false
          showInLegend: true
      tooltip:
        useHTML: false
      legend:
        borderColor: '#FFF'

      yAxis: options.yAxis or []
      series: options.series or []
    @build() unless _.isEmpty(@options.yAxis) and _.isEmpty(@options.series)

  set_yAxis: (yAxis) =>
    @options.yAxis.push yAxis

  set_series: (series) =>
    @options.series.push series

  set_xAxis_cat: (cat) =>
    if cat instanceof(Array)
      @options.xAxis.categories = cat
    else
      @options.xAxis.categories.push cat

  addSeries: =>
    @chart.addSeries @series

  unset_yAxis: =>
    if _.isEmpty @chart
      delete @chart
    else  
      @chart.options.yAxis = null
    @options.yAxis = []

  unset_series: =>
    if _.isEmpty @chart
      delete @chart
    else
      @chart.options.series = null
    @options.series = []

  build: =>
    @chart.destroy() unless @chart == undefined
    @chart = new Highcharts.Chart @options
    return @chart

  redraw: =>
    @chart.redraw()

  suitable_yAxis: (num) ->
    return 100000 if num in [10000..100000]
    return 10000 if num in [1000..10000]
    return 1000 if num in [100..1000]
    return 100 if num in [10..100]
    return 10 if num in [0..10]

