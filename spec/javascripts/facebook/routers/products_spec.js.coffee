describe "Product Router Facebook", ->
  beforeEach ->
    @id = 1
    @translate = new Backbone.Model()
    @translateStub = sinon.stub(App, "Translate").returns(@translate)
    @optionTypes = new Backbone.Collection()
    @optionTypesStub = sinon.stub(App.Collections, "OptionTypes").returns(@optionTypes)

    @router = new App.Routers.Products()

  afterEach ->
    @translateStub.restore()
    @optionTypesStub.restore()

  describe "initialize", ->
    it "creates a translateStub model", ->
      expect(@translateStub).toHaveBeenCalledOnce()
      expect(@translateStub).toHaveBeenCalledWithExactly()

    it "creates a optionTypesStub collection", ->
      expect(@optionTypesStub).toHaveBeenCalledOnce()
      expect(@optionTypesStub).toHaveBeenCalledWithExactly()

  describe "routes", ->
    beforeEach ->
      @routes = 
        "/products/:id": "show"
      @routeSpy =sinon.spy()
      try
        Backbone.history.start({silent: true, pushState: true})
      catch e
      @router.navigate("elsewhere")

    it "handles /products/:id route", ->
      expect(@router["routes"]["/products/:id"]).toEqual(@routes["/products/:id"])

    describe "handler", ->
      beforeEach ->
        @fetchTranslateStub = sinon.stub(@translate, 'fetch').yieldsTo('success', @translate)

      afterEach ->
        @fetchTranslateStub.restore()

      describe "show handler", ->
        beforeEach ->
          @product = new Backbone.Model()
          @product.set "id", 1
          @productStub = sinon.stub(App, "Product").returns(@product)
          @productFetchStub = sinon.stub(@product, "fetch").returns(@product)
          @shop = new Backbone.Model()
          @shop.set "uuid", "5550eae6-2e82-6350-3355-0cd81fa843aa"
          @shopStub = sinon.stub(App, "Shop").returns(@shop)
          @shopFetchStub = sinon.stub(@shop, "fetch").returns(@shop)
          @productsShowViewStub = sinon.stub(App.Views.Products, "Show").returns(new Backbone.View)
          @productsSearchProductViewStub = sinon.stub(App.Views.Products, "SearchProduct").returns(new Backbone.View)

        afterEach ->
          @productStub.restore()
          @productFetchStub.restore()
          @shopStub.restore()
          @shopFetchStub.restore()
          @productsShowViewStub.restore()
          @productsSearchProductViewStub.restore()

        it "is fired visiting /products/:id route", ->
          #console.log "nicolas"
          @router.bind("route:show", @routeSpy)
          @router.navigate("#/products/#{@id}", true)
          expect(@routeSpy).toHaveBeenCalledOnce()
          expect(@routeSpy).toHaveBeenCalledWithExactly("#{@id}")

        describe "testing method show", ->
          beforeEach ->
            @router.show("#{@id}")

          it "fetches translation", ->
            expect(@fetchTranslateStub).toHaveBeenCalledOnce()

          it "fetches products", ->
            expect(@productFetchStub).toHaveBeenCalledOnce()

