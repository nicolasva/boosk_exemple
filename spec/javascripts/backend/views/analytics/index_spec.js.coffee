describe 'App.Views.Analytics.Index', ->
  beforeEach ->
    App.Views.Analytics.Index.prototype.template = JST['app/assets/javascripts/backend/templates/analytics/index']
    @analytics = new Backbone.Model()
    @shop = new Backbone.Model()
    @translate = new Backbone.Model
      activerecord:
        models:
          shop: ""
      views:
        common:
          menu:
            {}
    @products = new Backbone.Collection()
    @analyticsStub = sinon.stub(window, 'Analytics').returns
      draw_chart: () ->

    @view = new App.Views.Analytics.Index
      analytics: @analytics
      shop: @shop
      translate: @translate
      products: @products

  afterEach ->
    @analyticsStub.restore()

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
        products: @products
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
      expect(Haml.render).toHaveBeenCalledOnce()

  describe 'events', ->
    it 'handles analytics type change', ->
      expect(@view.events['click .action']).toEqual('change_action')

    it 'handles analytics chart type change', ->
      expect(@view.events['click .chart_type']).toEqual('change_type')

    it 'handles plan upgrade', ->
      expect(@view.events['click .disabled-analytics + button']).toEqual('upgrade_plan')

    it 'handles analytics period change', ->
      expect(@view.events['change #period']).toEqual('change_period')

    it 'handles analytics range change', ->
      expect(@view.events['submit #chart-by-range']).toEqual('chart_by_range')
