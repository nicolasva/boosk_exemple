describe "Checkouts Router", ->
  beforeEach ->
    @translate = new Backbone.Model()
    @translateStub = sinon.stub(App, "Translate").returns(@translate)
    @carts = new Backbone.Collection
    @cartsCollectionStub = sinon.stub(App.Collections, "Carts").returns(@carts)
    @geographicRegions = new Backbone.Collection
    @geographicRegionsCollectionStub = sinon.stub(App.Collections, "GeographicRegions").returns(@geographicRegions)
    @contact = new Backbone.Model()
    @contactStub = sinon.stub(App, "Contact").returns(@contact)

    @router = new App.Routers.Checkout()

  afterEach ->
    @translateStub.restore()
    @cartsCollectionStub.restore()
    @geographicRegionsCollectionStub.restore()
    @contactStub.restore()

  describe "initialize", ->
    it "creates a translateStub model", ->
      expect(@translateStub).toHaveBeenCalledOnce()
      expect(@translateStub).toHaveBeenCalledWithExactly()

  describe "routes", ->
    beforeEach ->
      @routes = 
        "/shops/checkouts" : "new_step_1"
        "/shops/checkouts/step2" : "new_step_2"
      @routeSpy = sinon.spy()
      try
        Backbone.history.start({silent: true, pushState: true})
      catch e
      @router.navigate("elsewhere")

    it "handles /shops/checkouts route", ->
      expect(@router["routes"]["/shops/checkouts"]).toEqual(@routes["/shops/checkouts"])

    it "handles /shops/checkouts/step2 route", ->
      expect(@router["routes"]["/shops/checkouts/step2"]).toEqual(@routes["/shops/checkouts/step2"])

    describe "new_step_1 handler", ->
      beforeEach ->
        @fetchTranslateStub = sinon.stub(@translate, 'fetch').yieldsTo('success', @translate)
        @fetchGeographicRegions = sinon.stub(@geographicRegions, 'fetch').yieldsTo('success', @geographicRegions)
        @fetchCartsCollectionStub = sinon.stub(@carts, 'fetch').yieldsTo('success', @carts)
        @viewCheckoutsNewStep1 = sinon.stub(App.Views.Checkouts.New, "Step1").returns(new Backbone.View)

      afterEach ->
        @fetchCartsCollectionStub.restore()
        @fetchTranslateStub.restore()
        @fetchGeographicRegions.restore()
        @viewCheckoutsNewStep1.restore()

      it "is fired visiting /shops/checkouts route", ->
        @router.bind("route:new_step_1", @routeSpy)
        @router.navigate("#/shops/checkouts", true)
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWithExactly()

      it "fetches translation", ->
        @router.new_step_1()
        expect(@fetchTranslateStub).toHaveBeenCalledOnce()

      it "fetches GeographicRegions collection", ->
        @router.new_step_1()
        expect(@fetchGeographicRegions).toHaveBeenCalledOnce()

      it "creates a checkout new step1 view", ->
        @router.new_step_1()
        expect(@viewCheckoutsNewStep1).toHaveBeenCalledOnce()

    describe "new_step_2 handler", ->
      beforeEach ->
        @fetchTranslateStub = sinon.stub(@translate, 'fetch').yieldsTo('success', @translate)
        @fetchCartStub = sinon.stub(@carts, 'fetch').yieldsTo('success', @carts)
        @viewCheckoutsNewStep2 = sinon.stub(App.Views.Checkouts.New, "Step2").returns(new Backbone.View)

      afterEach ->
        @fetchTranslateStub.restore()
        @fetchCartStub.restore()
        @viewCheckoutsNewStep2.restore()

      it "is fired visiting /shops/checkouts/step2 route", ->
        @router.bind("route:new_step_2", @routeSpy)
        @router.navigate("#/shops/checkouts/step2", true)
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWithExactly()

      it "fetches translation", ->
        @router.new_step_2()
        expect(@fetchTranslateStub).toHaveBeenCalledOnce()

      it "fetches carts Collection", ->
        @router.new_step_2()
        expect(@fetchCartStub).toHaveBeenCalledOnce()

      it "creates a checkouts new step2 view", ->
        @router.new_step_2()
        expect(@viewCheckoutsNewStep2).toHaveBeenCalledOnce()

      it "creates a checkouts new_step_2 view", ->
        @router.new_step_2()
        expect(@viewCheckoutsNewStep2).toHaveBeenCalledOnce() 
