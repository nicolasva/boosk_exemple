describe "Orders Router Facebook", ->
  beforeEach ->
    @order = new Backbone.Model()
    @orderStub = sinon.stub(App, "Order").returns(@order)
    @router = new App.Routers.Orders()

  afterEach ->
    @orderStub.restore()

  describe "initialize", ->
    it "creates a orderStub model", ->
      expect(@orderStub).toHaveBeenCalledOnce()

  describe "routes", ->
    beforeEach -> 
      @routes = 
        "/products/:product_id/orders": "create"
      @routeSpy = sinon.spy()
      try
        Backbone.history.start({silent: true, pushState: true})
      catch e
      @router.navigate("elsewhere")

    it "handles /products/:product_id/orders route", ->
      expect(@router["routes"]["/products/:product_id/orders"]).toEqual(@routes["/products/:product_id/orders"])


