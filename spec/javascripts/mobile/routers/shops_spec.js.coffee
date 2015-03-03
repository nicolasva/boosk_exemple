describe "Shops Router mobile", ->
  beforeEach ->
    App.current_shop = 1
    @model = new Backbone.Model()
    @translateStub = sinon.stub(App, "Translate").returns(@model)
    @router = new App.Routers.Shops()

  afterEach ->
    @translateStub.restore()

  describe "initialize", ->
    it "creates a shopModelStub model", ->
      expect(@translateStub).toHaveBeenCalledOnce()
      expect(@translateStub).toHaveBeenCalledWithExactly()

  describe "routes", ->
    beforeEach ->
      @routes =
        "/shops/:id" : "show"
      @routeSpy = sinon.spy()
      try
        Backbone.history.start({silent: true, pushState: true})
      catch e
      @router.navigate("elsewhere")

    it "handles /shops/:id route", ->
      expect(@router["routes"]["/shops/:id"]).toEqual(@routes["/shops/:id"])

