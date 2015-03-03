describe 'App.Views.Dashboard.Index', ->
  beforeEach ->
    App.Views.Dashboard.Index.prototype.template = JST['app/assets/javascripts/backend/templates/dashboard/index']
    App.Views.Dashboard.Index.prototype.support_block = JST['app/assets/javascripts/backend/templates/shared/support_block']

    $("<div id='app'></div>").appendTo("body")

    @analytics = new Backbone.Model()
    @translate = new Backbone.Model
      shop: ""
      product: ""
      m_views: ""
      m_orders: ""
      m_want: ""
      m_have: ""
      m_sales: ""
      from: ""
      ok: ""
      to: ""
      you_want: ""
      date:
        formats:
          default: ""
      views:
        dashboard:
          last_order: ""
          no_orders: ""
          order_status: ""
          top_product: ""
          users_actions: ""
          people_who_like_one_of_your_product: ""
          people_who_tweet_one_of_your_product: ""
          people_who_pin_one_of_your_product: ""
          people_who_want_one_of_your_product: ""
          people_who_have_one_of_your_product: ""
          choose_period: ""
          setting_taxes: ""
          setting_shipping_methods: ""
          setting_taxons: ""
          setting_products: ""
          setting_paypal_account: ""
        order:
          status:
            in_progress:
              action: ""
              display: ""
            shipped:
              action: ""
              display: ""
            delivered:
              action: ""
              display: ""
            closed:
              action: ""
              display: ""
            canceled:
              action: ""
              display: ""
        plan:
          change_my_plan: ""
      activerecord:
        models:
          order: ""
      one_article: ""
      many_article: ""
      at: ""
      at_time: ""

    @shop = new Backbone.Model()
    @shop_functionnality = new Backbone.Model()
    @products = new Backbone.Collection()

    @productsStub = sinon.stub(App.Collections, 'Products').returns(@products)
    @fetchProductsStub = sinon.stub(@products, 'fetch').yieldsTo('success', @products)

    @topProductsByActionStub = sinon.stub(App.Views.Dashboard, 'TopProductsByAction').returns(new Backbone.View())
    @view = new App.Views.Dashboard.Index
      analytics: @analytics
      shop: @shop
      translate: @translate
      shop_functionnality: @shop_functionnality

  afterEach ->
    @topProductsByActionStub.restore()
    @fetchProductsStub.restore()
    @productsStub.restore()
    $("#app").remove()

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'binds on "app" element', ->
      expect(@view.$el.selector).toEqual("#app")

    it 'renders immediately', ->
      @view.initialize
        analytics: @analytics
        shop: @shop
        translate: @translate
        shop_functionnality: @shop_functionnality
      expect(@renderStub).toHaveBeenCalledOnce()

  describe 'rendering', ->
    beforeEach ->
      sinon.spy(Haml, 'render')
      sinon.spy(@view, 'template')
      @view.render()

    afterEach ->
      Haml.render.restore()
      @view.template.restore()

    it 'returns the view object', ->
      expect(@view.render()).toEqual(@view)

    it 'calls template method', ->
      expect(@view.template).toHaveBeenCalledOnce()
      expect(@view.template).toHaveBeenCalledWithExactly()

    it 'calls Haml render method', ->
      expect(Haml.render).toHaveBeenCalledTwice()

  describe 'events', ->
    it 'handles correct events', ->
      expect(@view.events).toEqual
        "click #top-products-by-action .menu span": "top_products_by_context"
        "click #dashboard-by-range": "dashboard_by_range"
        "change .range_action": "dashboard_by_range"
        "click .disabled-top-products + button": "upgrade_plan"
