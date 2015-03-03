describe "Paginations Router", ->
  beforeEach ->
    @nextpage = 2
    @router = new App.Routers.Paginations()

  describe "routes", ->
    beforeEach ->
      @routes = 
        "/paginations/show/nextpage/:nextpage": "show"

      @routeSpy = sinon.spy()
      try 
        Backbone.history.start({silent: true, pushState: true})
      catch e
      @router.navigate("elsewhere")

    it "handles /paginations/show/nextpage/:nextpage route", ->
      expect(@router["routes"]["/paginations/show/nextpage/:nextpage"]).toEqual(@routes["/paginations/show/nextpage/:nextpage"])

