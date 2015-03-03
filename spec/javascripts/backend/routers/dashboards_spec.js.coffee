describe "Dashboard Router", ->
  beforeEach ->
   # App.current_shop = 1

    @shops = new Backbone.Collection
    @shopsStub = sinon.stub(App.Collections, 'Shops').returns(@shops)

 #   @analytics = new Backbone.Model
 #   @analyticsStub = sinon.stub(App, 'DashboardAnalytic').returns(@analytics)

 #   @translate = new Backbone.Model
 #   @translateStub = sinon.stub(App, 'Translate').returns(@translate)

    @router = new App.Routers.Dashboard()

  afterEach ->
    @shopsStub.restore()
  #  @analyticsStub.restore()
  #  @translateStub.restore()

  describe "when initialized", ->
    it "creates a shops collection", ->
      expect(@shopsStub).toHaveBeenCalledOnce()
      expect(@shopsStub).toHaveBeenCalledWithExactly()

#    it "fetches analytic dashboard", ->
#      expect(@analyticsStub).toHaveBeenCalledOnce()
#      expect(@analyticsStub).toHaveBeenCalledWithExactly()

#    it "creates a translate instance", ->
#      expect(@translateStub).toHaveBeenCalledOnce()
#      expect(@translateStub).toHaveBeenCalledWithExactly()

  describe "routes", ->
    beforeEach ->
      @routes =
        "/dashboard": "index"
      @routeSpy = sinon.spy()
      try
        Backbone.history.start({silent:true, pushState:true})
      catch e
      @router.navigate("elsewhere")

    it "handles /dashboard route", ->
      expect(@router["routes"]["/dashboard"]).toEqual(@routes["/dashboard"])


