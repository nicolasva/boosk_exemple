describe "Shop Router Facebook", ->
  beforeEach ->
    @translate = new Backbone.Model()
    @translateStub = sinon.stub(App, "Translate").returns(@translate)
    @router = new App.Routers.Shops()
  afterEach ->
    @translateStub.restore()

  describe "intialize", ->
    it "creates a translate model", ->
      expect(@translateStub).toHaveBeenCalledOnce()
      expect(@translateStub).toHaveBeenCalledWithExactly()

  describe "routes", ->
    beforeEach ->
      @routes = 
        "/shops/:id": "show"

      @routeSpy = sinon.spy()
      try
        Backbone.history.start({silent: true, pushState: true})
      catch e
      @router.navigate("elsewhere")

    it "handles /shops/:id route", ->
      expect(@router["routes"]["/shops/:id"]).toEqual(@routes["/shops/:id"])

    describe "handler", ->
      beforeEach ->
        @fetchTranslateStub = sinon.stub(@translate, 'fetch').yieldsTo('success', @translate)

      afterEach ->
        @fetchTranslateStub.restore()

      describe "Shops show handler", ->
        beforeEach ->
          App.current_shop = 1
          @shop = new Backbone.Model(uuid: App.current_shop)
          @shopStub = sinon.stub(App, "Shop").returns(@Shop)
          @fetchTranslateStub = sinon.stub(@translate, "fetch").yieldsTo('success', @translate)
          @fetchShopStub = sinon.stub(@shop, "fetch").yieldsTo('success', @shop)
          @viewShopsShowStub = sinon.stub(App.Views.Shops, "Show").returns(new Backbone.View)

        afterEach ->
          @shopStub.restore()
          @fetchTranslateStub.restore()
          @fetchShopStub.restore()
          @viewShopsShowStub.restore()

        it "is fired visiting /shops/:id route", ->
          @router.bind("route:show", @routeSpy)
          @router.navigate("#/shops/#{App.current_shop}", true)
          expect(@routeSpy).toHaveBeenCalledOnce()
          expect(@routeSpy).toHaveBeenCalledWithExactly()

        describe "testing method shops show", ->
          beforeEach ->
            @router.show("#{App.current_shop}")

          it "creates a shop model", ->
            expect(@shopStub).toHaveBeenCalledOnce()
            expect(@shopStub).toHaveBeenCalledWithExactly()

          it "fetches translation", ->
            expect(@fetchTranslateStub).toHaveBeenCalledOnce()

          it "fetches shop", ->
            expect(@shopsStub).toHaveBeenCalledOnce()

          it "creates a shops show view", ->
            expect(@viewShopsShowStub).toHaveBeenCalledOnce()
            expect(@viewShopsShowStub).toHaveBeenCalledWithExactly(shop: @shop, translate: @translate)
