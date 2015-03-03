describe "ProductVariants Router", ->
  beforeEach ->
    @product_id = 1
    @id = 1
    @productVariant = new Backbone.Model()
    @productVariantStub = sinon.stub(App, "ProductVariant").returns(@productVariant)

    @router = new App.Routers.ProductVariants()

  afterEach ->
    @productVariantStub.restore()

  describe "initialize", ->
    it "creates a productVariant model", ->
      expect(@productVariantStub).toHaveBeenCalledOnce()
      expect(@productVariantStub).toHaveBeenCalledWithExactly()

  describe "routes", ->
    beforeEach ->
      @routes = 
        "/products/:product_id/product_variants/:id": "show"

      @routeSpy = sinon.spy()
      try
        Backbone.history.start({silent: true, pushState: true})
      catch e
      @router.navigate("elsewhere")

    it "handles /products/:product_id/product_variants/:id route", ->
      expect(@router["routes"]["/products/:product_id/product_variants/:id"]).toEqual(@routes["/products/:product_id/product_variants/:id"])

    describe "ProductVariants handler", ->
      beforeEach ->
        @productVariant.set 'id', "1"
        @productVariant.set 'product_id', '1'
        @productVariantFetchStub = sinon.stub(@productVariant, "fetch").returns(@productVariant)
        @productVariantsViewStub = sinon.stub(App.Views.ProductVariants, "ShowDetailProductVariants").returns(new Backbone.View)

      afterEach ->
        @productVariantFetchStub.restore()
        @productVariantsViewStub.restore()
      
      it "is fired visiting /products/:product_id/product_variants/:id route", ->
        #console.log "nicolas"
        @router.bind("route:show", @routeSpy)
        @router.navigate("#/products/#{@product_id}/product_variants/#{@id}", true)
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWithExactly('1','1')

      it "gets the good product_variants", ->
        @router.show('1', '1')
        expect(@productVariantFetchStub).toHaveBeenCalledOnce()
