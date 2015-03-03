class App.Views.Dashboard.Index extends Backbone.View
  el: '#app'
  template: JST["backend/templates/dashboard/index"]
  support_block: JST["backend/templates/shared/support_block"]

  events:
    "click #top-products-by-action .menu span": "top_products_by_context"
    "click #dashboard-by-range": "dashboard_by_range"
    "change .range_action": "dashboard_by_range"
    "click .disabled-top-products + button": "upgrade_plan"

  initialize: (options) ->
    @sanalytics = options.analytics
    @analytics = options.analytics.toJSON()
    @translate = options.translate.toJSON()
    @shop = options.shop.toJSON()
    @products = new App.Collections.Products
    @shop_functionnality = options.shop_functionnality
    @actions =
      0: { action: "week", display: @translate.seven_days_ago }
      1: { action: "month", display: @translate.this_month }
      2: {action: "last_month", display: @translate.this_last_month }
      3: { action: "year", display: @translate.this_year }
    @order_status_color =
      paid: "#ff6600"
      delivered: "#77e075"
      shipped: "#5fb4ff"
      canceled: "#ff3232"
      closed: "#bababa"
      default: "#dedede"
    self = @
    App.eventsDispatcher.trigger 'startLoading'
    @products.fetch
      success: ->
        self.render()
        tab_value_from = $(".datepicker.from").attr("value").split("/")
        tab_value_to = $(".datepicker.to").attr("value").split("/")
        month_from = tab_value_from[0]
        day_from = tab_value_from[1]
        year_from = tab_value_from[2]

        month_to = tab_value_to[0]
        day_to = tab_value_to[1]
        year_to = tab_value_to[2]
        
        datetime_from = self.translate.date.formats.default
        first_value = datetime_from.split("/")[0]
        if first_value == "%d"
          $(".datepicker.from").attr("value", day_from+"/"+month_from+"/"+year_from)
          $(".datepicker.to").attr("value", day_to+"/"+month_to+"/"+year_to)
        App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  upgrade_plan: (e) ->
    e.preventDefault()
    e.stopPropagation()
    new App.Views.Plans.BoxUpgrade
      message: @translate.views.dashboard.forbidden_plan

  top_products_by_context: (e) ->
    action = $(e.target).attr('data-action')
    $($(e.target).closest('.menu')[0]).find('.selected').removeClass('selected')
    $(e.target).addClass('selected')
    if @analytics.top_products_by_action?
      if @analytics.top_products_by_action[action]?
        @view = new App.Views.Dashboard.TopProductsByAction
          top_products:  @split_top_items(@analytics.top_products_by_action[action])
          products: @products
          action: action
          translate: @translate
          forbidden: _.has(@analytics, 'forbidden')

  split_top_items: (items) ->
    top3 =  (items[num] for num in [0..2])
    toprest = (items[num] for num in [3..9])
    return {top3: top3, toprest: toprest}


  dashboard_by_range: (e) ->
    App.eventsDispatcher.trigger 'startLoading'
    if $(e.target).hasClass('range_action')
      to_date = new Date(App.date_now_utc())
      switch $(e.target).val()
        when "week" then from_date = new Date(App.days_ago_to_utc(6))
        when "month" then from_date = new Date(to_date.getFullYear(), to_date.getMonth(), 1)
        when "last_month" 
          from_date = new Date(to_date.getFullYear(), to_date.getMonth() - 1, 1)
          to_date = new Date(to_date.getFullYear(), to_date.getMonth(), 1)
        when "year" then from_date = new Date(to_date.getFullYear(), 0, 1)

      $('.from').val(@formatDate(from_date))
      $('.to').val(@formatDate(to_date))
      @period = $(e.target).val()
      @sanalytics.from = @from = @formatDate(from_date)
      @sanalytics.to = @to = @formatDate(to_date)
    else
      @sanalytics.from = @from = @formatDate($(e.target).parent('.date').find('.from').val())
      @sanalytics.to = @to = @formatDate($(e.target).parent('.date').find('.to').val())
    self = @
    @sanalytics.fetch
      success: ->
        self.analytics = self.sanalytics.toJSON()
        self.render()
        App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  formatDate: (date) -> 
    datetime_from = @translate.date.formats.default
    first_value = datetime_from.split("/")[0]
    if first_value == "%d"
      "#{@pad(date.getDate())}/#{@pad(date.getMonth()+1)}/#{date.getFullYear()}"
    else
      "#{@pad(date.getMonth()+1)}/#{@pad(date.getDate())}/#{date.getFullYear()}"
    switch window.navigator.language
      when 'en'
        return "#{@pad(date.getMonth()+1)}/#{@pad(date.getDate())}/#{date.getFullYear()}"
      when 'fr'
        return "#{@pad(date.getDate())}/#{@pad(date.getMonth()+1)}/#{date.getFullYear()}"

  pad: (number) ->
    if number < 10 then "0" + number else "#{number}"

  find_offset: (obj) ->
    curX = curY = 0
    if obj.offsetParent
      while (true)
        curX += obj.offsetLeft
        curY += obj.offsetTop
        if (!(obj = obj.offsetParent))
          break
      return { x: curX, y: curY }

  rgbToHex: (r, g, b) ->
    if (r > 255 || g > 255 || b > 255)
      return false
    return ((r << 16) | (g << 8) | b).toString(16)


  change_count_orders: (key) ->
    unless key is 'default'
      $('.nb-orders').html(@analytics.order_stats[key])
      $('.nb-orders').show()


  draw_order_status: ->
    stats = @analytics.order_stats
    stats = {default: 1} if stats == null or _.isEmpty(stats)
    total = @count_by_reduce(stats)
    circle = (Math.PI * 2)
    start_angle = 0
    @canvas = document.getElementById("orders-stats")
    self = @

    @canvas.onmousemove = (e) ->
      pos = self.find_offset(self.canvas)
      x = e.pageX - pos.x
      y = e.pageY - pos.y
      coord = "x=" + x + ", y=" + y
      c = self.canvas.getContext('2d')
      p = c.getImageData(x, y, 1, 1).data
      color = "#" + ("000000" + self.rgbToHex(p[0], p[1], p[2])).slice(-6)
      match = false
      _.each self.order_status_color, (value, key) ->
        if value == color
          match = true
          $('.nb-orders').css('color', color)
          self.change_count_orders(key)
      $('.nb-orders').html('') unless match

    _.each stats, (value, key) ->
      percent = ((value/total) * 100)
      context = self.canvas.getContext('2d')
      context.beginPath()
      context.arc(80, 80, 50, ((start_angle * circle)/ 100), (((start_angle + percent) * circle) / 100), false)
      context.fillStyle = '#FFF'
      context.fill()
      context.lineWidth = 33
      context.strokeStyle = self.order_status_color[key]
      context.stroke()
      start_angle += percent

  general_products_stats: ->
    products_stats = {}
    if @analytics.general_products_stats?
      for stat in @analytics.general_products_stats
        products_stats[stat['_id']] = stat['value'].count
    return products_stats

  count_by_reduce: (o)->
    v = _.reduce(_.values(o), (p, n) ->
      return p + n
    , 0)
    return v

  render: ->
    if $.browser.msie and parseInt($.browser.version < 9)
      new App.Views.Notice(message: @translate.views.dashboard.warning_ie, type: 'error', el: '#notice', displayLength: 15000)
    $(@el).html(Haml.render(@template(), {locals: {
      shop_views: @analytics.shop_views
      shop_earning: @analytics.shop_earning
      order_stats: @count_by_reduce(@analytics.order_stats)
      general_products_stats: @general_products_stats()
      last_orders: @analytics.last_orders
      shop: @shop
      translate: @translate
      shop_functionnality: @shop_functionnality.toJSON()
      actions: @actions
      period: @period
      from: @from
      to: @to
      nb_products: @analytics.nb_products
      products: @products.toJSON()
      forbidden: _.has(@analytics.top_products_by_action, 'forbidden')
    } }))

    $('#shop-preview').popover()

    self = @
    App.devises().each (devise) ->
      self.$("#infos .devise-symbol").html(devise.get('symbol')) if self.shop.devise is devise.get('iso')

    @draw_order_status()

    if @analytics.top_products_by_action?
      if _.has(@analytics.top_products_by_action, 'forbidden')
        @analytics.forbidden = true
        @analytics.top_products_by_action = @sanalytics.fake_data
      if @analytics.top_products_by_action.like?
        @view = new App.Views.Dashboard.TopProductsByAction
          top_products: @split_top_items(@analytics.top_products_by_action.like)
          products: @products
          action: "like"
          translate: @translate
          forbidden: _.has(@analytics, 'forbidden')
    else
      @view = new App.Views.Dashboard.TopProductsByAction
        top_products:  @split_top_items([])
        products: @products
        translate: @translate
        forbidden: _.has(@analytics.top_products_by_action, 'forbidden')

    $('.datepicker').datepicker($.datepicker.regional[window.navigator.language])

    if @period == undefined and @from == undefined
      $('.to').val(@formatDate(new Date(App.date_now_utc())))
      $('.from').val(@formatDate(new Date(App.days_ago_to_utc(6))))
    $("#shop_functionnality").remove() if $('#shop_functionnality h2 + div > *').length == 0
    $("#sidebar").append(Haml.render(@support_block(),
      locals:
        translate: @translate
    ))
    return @
