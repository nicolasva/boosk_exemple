describe "TaxonProducts Router", ->
  beforeEach ->
    App.current_shop = "5550eae6-2e82-6350-3355-0cd81fa843aa"
    @taxonomy_id = 1
    @taxon_id = 1
    @translate = new Backbone.Model()
    @translateStub = sinon.stub(App, "Translate").returns(@translate)
    @taxonProducts = new Backbone.Collection()
    @taxonProductsStub = sinon.stub(App.Collections, "TaxonProducts").returns(@TaxonProducts)
   
    @router = new App.Routers.TaxonProducts()

  afterEach ->
    @translateStub.restore()
    @taxonProductsStub.restore()

  describe "initialize", ->
    it "creates a translate model", ->
      expect(@translateStub).toHaveBeenCalledOnce()
      expect(@translateStub).toHaveBeenCalledWithExactly()

    it "creates a taxon products collection", ->
      expect(@taxonProductsStub).toHaveBeenCalledOnce()
      expect(@taxonProductsStub).toHaveBeenCalledWithExactly()

  describe "routes", ->
    beforeEach ->
      @routes = 
        "/taxonomies/:taxonomy_id/taxons/:taxon_id/taxon_products" : "index"

      @routeSpy = sinon.spy()
      try
        Backbone.history.start({silent: true, pushState: true})
      catch e
      @router.navigate("elsewhere")

    it "handles /taxonomies/:taxonomy_id/taxons/:taxon_id/taxon_products route", ->
      expect(@router["/products/:product_id/product_variants/:id"]).toEqual(@routes["/products/:product_id/product_variants/:id"])

    describe "handler", ->
      beforeEach ->
        @fetchTranslateStub = sinon.stub(@translate, 'fetch').yieldsTo('success', @translate)

      afterEach ->
        @fetchTranslateStub.restore()

      describe "index handler", ->
        beforeEach ->
          @shop = new Backbone.Model(uuid: App.current_shop)
          @shopStub = sinon.stub(App, "Shop").returns(@shop) 
          @fetchShopStub = sinon.stub(@shop, 'fetch').yieldsTo('success', @shop)
          @viewTaxonProductsIndex = sinon.stub(App.Views.TaxonProducts, "Index").returns(new Backbone.View)

        afterEach ->
          @shopStub.restore()
          @fetchShopStub.restore()
          @viewTaxonProductsIndex.restore()


        it "is fired visiting /taxonomies/:taxonomy_id/taxons/:taxon_id/taxon_products route", ->
          @router.bind("route:index", @routeSpy)
          @router.navigate("/taxonomies/#{@taxonomy_id}/taxons/#{@taxon_id}/taxon_products", true)  

