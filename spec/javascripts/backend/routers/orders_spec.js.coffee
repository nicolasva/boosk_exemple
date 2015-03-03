describe "Order Router", ->
  beforeEach ->
    App.current_shop = 1
    @orders = new Backbone.Collection
    @ordersStub = sinon.stub(App.Collections, 'Orders').returns(@orders)

    @order = new Backbone.Model
    @orderStub = sinon.stub(App, 'Order').returns(@order)

    @translate = new Backbone.Model
    @translateStub = sinon.stub(App, 'Translate').returns(@translate)

    @router = new App.Routers.Orders()

  afterEach ->
    @ordersStub.restore()
    @orderStub.restore()
    @translateStub.restore()

  describe "when initialized", ->
    it "creates an order collection", ->
      expect(@ordersStub).toHaveBeenCalledOnce()
      expect(@ordersStub).toHaveBeenCalledWithExactly()

    it "creates a translate instance", ->
      expect(@translateStub).toHaveBeenCalledOnce()
      expect(@translateStub).toHaveBeenCalledWithExactly()

  describe "routes", ->
    beforeEach ->
      @routes =
        "/orders": "index"
        "/orders/:id": "show"
      @order_id = 1
      @routeSpy = sinon.spy()
      try
        Backbone.history.start({silent:true, pushState:true})
      catch e
      @router.navigate("dtc")

    it "handles /orders route", ->
      expect(@router["routes"]["/orders"]).toEqual(@routes["/orders"])

    it "handles /orders/:id route", ->
      expect(@router["routes"]["/orders/:id"]).toEqual(@routes["/orders/:id"])

    describe "index handler", ->
      beforeEach ->
        @fetchTranslateStub = sinon.stub(@translate, 'fetch').yieldsTo('success', @translate)
        @fetchOrdersStub = sinon.stub(@orders, 'fetch').yieldsTo('success', @orders)
        @ordersIndexViewStub = sinon.stub(App.Views.Orders, 'Index').returns(new Backbone.View)

      afterEach ->
        @fetchTranslateStub.restore()
        @fetchOrdersStub.restore()
        @ordersIndexViewStub.restore()

      it "is fired visiting /orders route", ->
        @router.bind("route:index", @routeSpy)
        @router.navigate("#/orders", true)
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWithExactly()

      it "fetches translation", ->
        @router.index()
        expect(@fetchTranslateStub).toHaveBeenCalledOnce()

      it "fetches orders collection", ->
        @router.index()
        expect(@fetchOrdersStub).toHaveBeenCalledOnce()

      it "creates a orders index view", ->
        @router.index()
        expect(@ordersIndexViewStub).toHaveBeenCalledOnce()
        expect(@ordersIndexViewStub).toHaveBeenCalledWithExactly(orders: @orders, translate: @translate)

    describe "show handler", ->
      beforeEach ->
        @fetchOrdersStub = sinon.stub(@orders, 'fetch').yieldsTo('success', @orders)
        @fetchOrderStub = sinon.stub(@order, 'fetch').yieldsTo('success', @order)
        @fetchTranslateStub = sinon.stub(@translate, 'fetch').yieldsTo('success', @translate)
        @orderShowViewStub = sinon.stub(App.Views.Orders, 'Show').returns(new Backbone.View)

      afterEach ->
        @fetchTranslateStub.restore()
        @fetchOrderStub.restore()
        @orderShowViewStub.restore()

      it "is fired visiting /orders route", ->
        @router.bind("route:show", @routeSpy)
        @router.navigate("#/orders/#{@order_id}", true)
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWithExactly("1")

      it "fetches translation", ->
        @router.show()
        expect(@fetchTranslateStub).toHaveBeenCalledOnce()

      it "fetches order model", ->
        @router.show()
        expect(@fetchOrderStub).toHaveBeenCalledOnce()

      it "creates a orders index view", ->
        @router.show()
        expect(@orderShowViewStub).toHaveBeenCalledOnce()
        expect(@orderShowViewStub).toHaveBeenCalledWithExactly(order: @order, translate: @translate)
