class App.Analytic extends Backbone.Model

  m_kpis: ['like','tweet','want','have','pin','order']

  fake_result:
    products_charts:
      like: [
        {
          value:
            count: 5
            date: App.date_now_utc()
        }
        {
          value:
            count: 2
            date: App.days_ago_to_utc(3)
        }
        {
          value:
            count: 6
            date: App.days_ago_to_utc(5)
        }
      ]
    shop_charts:
      view: [
        {
          value:
            count: 5
            date: App.date_now_utc()
        }
        {
          value:
            count: 2
            date: App.days_ago_to_utc(3)
        }
      ]
    order_charts:
      paid: [
        {
          value:
            count: 5
            date: App.date_now_utc()
        }
        {
          value:
            count: 2
            date: App.days_ago_to_utc(3)
        }
      ]

  url: ->
    range = "?#{$.param({from: @format_date(@from), to: @format_date(@to)})}" if @from? and @to?
    taxon_filter = "?#{$.param({taxon_id: @taxon_filter})}" if @taxon_filter?
    products_filter = "?#{App.format_array_params_get_request('product_ids',@products_filter)}" if @products_filter?
    return "/shops/#{App.current_shop}/analytics#{range ? ''}#{taxon_filter ? ''}#{products_filter ? ''}"

  initialize: (options) ->
    if options?
      if options.fake == true
        @.forbidden = true
        @.unset('fake')
        @.set @fake_result

  parse: (attributes) ->
    if attributes.product_charts?
      for c in attributes.products_charts.cart
        o = _.find attributes.products_charts.order,(o) -> return c.value.date is o.value.date
        c.value.count -= o.value.count if o?
    return attributes

  format_date: (date) ->
    switch window.navigator.language
      when 'fr'
        return "#{date.split('/')[0]}-#{date.split('/')[1]}-#{date.split('/')[2]}"
      when 'en'
        return "#{date.split('/')[1]}-#{date.split('/')[0]}-#{date.split('/')[2]}"

  format_kpis: ->
    self = @
    _.map @.toJSON().products_kpis, (product) ->
      product_kpi = { product: product.product, kpis: [] , id: product.product.uuid }
      for k in self.m_kpis
        v = _.find product.kpis, (t) ->
          return t._id == k
        v = if v != undefined then v.value.count else 0
        product_kpi['kpis'].push({ action: k, value: v })
      return product_kpi

  get_top_products: (action,n=10) ->
    _.sortBy(@format_kpis(), (g) ->
      return _.find(g.kpis, (f) ->
        return f.action is action).value
    ).splice(0,n).reverse()
