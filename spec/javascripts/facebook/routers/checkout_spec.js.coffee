describe "Checkout Router Facebook", ->
  beforeEach ->
    @translate = new Backbone.Model()
    @translateStub = sinon.stub(App, "Translate").returns(@translate)
    @address = new Backbone.Model()
    @addressStub = sinon.stub(App, "Address").returns(@address)
    @order = new Backbone.Model()
    @orderStub = sinon.stub(App, "Order").returns(@order)
    @router = new App.Routers.Checkout()

  afterEach ->
    @translateStub.restore()
    @addressStub.restore()
    @orderStub.restore()

  describe "initialize", ->
    it "creates a translateStub model", ->
      expect(@translateStub).toHaveBeenCalledOnce()
      expect(@translateStub).toHaveBeenCalledWithExactly()

    it "creates a addressStub model", ->
      expect(@addressStub).toHaveBeenCalledOnce()
      expect(@addressStub).toHaveBeenCalledWithExactly()

    it "creates a orderStub model", ->
      expect(@orderStub).toHaveBeenCalledOnce()
      expect(@orderStub).toHaveBeenCalledWithExactly()

  describe "routes", ->
    beforeEach ->
      @routes =
        "/shops/checkouts" : "checkout"
        "/shops/checkouts/success" : "success_order"
        "/shops/checkouts/cancel_order" : "cancel_order"
      @routeSpy = sinon.spy()
      try 
        Backbone.history.start({silent: true, pushState: true})
      catch e
      @router.navigate("elsewhere")

    it "handles /shops/checkouts route", ->
      expect(@router["routes"]["/shops/checkouts"]).toEqual(@routes["/shops/checkouts"])

    it "handles /shops/checkouts/success route", ->
      expect(@router["routes"]["/shops/checkouts/success"]).toEqual(@routes["/shops/checkouts/success"])

    it "handles /shops/checkouts/cancel_order", ->
      expect(@router["routes"]["/shops/checkouts/cancel_order"]).toEqual(@routes["/shops/checkouts/cancel_order"])

   
    describe "handler", ->
      beforeEach ->
        @fetchTranslateStub = sinon.stub(@translate, 'fetch').yieldsTo('success', @translate)

      afterEach ->
        @fetchTranslateStub.restore()

      describe "checkout handler", ->
        beforeEach ->
          @carts = new Backbone.Collection
          @cartsCollectionStub = sinon.stub(App.Collections, "Carts").returns(@carts)
          @fetchCartsStub = sinon.stub(@carts, 'fetch').yieldsTo('success', @carts)
          @viewCheckoutCheckout = sinon.stub(App.Views.Checkout, "Checkout").returns(new Backbone.View)
        
        afterEach ->
          @cartsCollectionStub.restore()
          @fetchCartsStub.restore()
          @viewCheckoutCheckout.restore()

        it "is fired visiting /shops/checkouts route", ->
          @router.bind("route:checkout", @routeSpy)
          @router.navigate("#/shops/checkouts", true)
          expect(@routeSpy).toHaveBeenCalledOnce()
          expect(@routeSpy).toHaveBeenCalledWithExactly()

        describe "testing method checkout", ->
          beforeEach ->
            @router.checkout()

          it "fetches translation", ->
            expect(@fetchTranslateStub).toHaveBeenCalledOnce()


          it "fetches carts", ->
            expect(@fetchCartsStub).toHaveBeenCalledOnce()

          it "creates a checkout new checkout view", ->
            expect(@viewCheckoutCheckout).toHaveBeenCalledOnce()
            expect(@viewCheckoutCheckout).toHaveBeenCalledWithExactly(carts: @carts, address: @address, translate: @translate)

