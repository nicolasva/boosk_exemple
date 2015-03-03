describe 'App.Views.Orders.Index', ->
  beforeEach ->
    App.Views.Orders.Index.prototype.template = JST['app/assets/javascripts/backend/templates/orders/index']

    @orders = new Backbone.Collection()
    @translate = new Backbone.Model
      views:
        order:
          status:
            paid:
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

    @view = new App.Views.Orders.Index
      orders: @orders
      translate: @translate

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'should create a DIV element', ->
      expect(@view.el.tagName).toEqual("DIV")

    it "doesn't render immediately", ->
      @view.initialize
        analytics: @analytics
        shop: @shop
        translate: @translate
        shop_functionnality: @shop_functionnality
      expect(@renderStub).not.toHaveBeenCalled()

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
    it 'handles correct events', ->
      expect(@view.events).toEqual
       "click .select-all": "select_all_orders"
       "change select[name='action']": "change_status"