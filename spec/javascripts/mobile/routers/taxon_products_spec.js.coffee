describe "TaxonProducts Router", ->
  beforeEach ->
    @collection = new Backbone.Collection
    @taxonProductsStub = sinon.stub(App.Collections, "TaxonProducts").returns(@collection)
    @router = new App.Routers.TaxonProducts()

  afterEach ->
    @taxonProductsStub.restore()

  describe "when initialized", ->
    it "creates a taxonProducts collection", ->
      expect(@taxonProductsStub).toHaveBeenCalledOnce()
      expect(@taxonProductsStub).toHaveBeenCalledWithExactly()

  describe "routes", ->
    beforeEach ->
      @routes = 
        "/taxonomies/:taxonomy_id/taxons/:taxon_id" : "index"
      @taxonomy_id = 1
      @taxon_id = 2
      @routeSpy = sinon.spy()
      try
        Backbone.history.start({slient: true, pushState: true})
      catch e
      @router.navigate("elsewhere")

    it "handles /taxonomies/:taxonomy_id/taxons/:taxon_id route", ->
      expect(@router["routes"]["/taxonomies/:taxonomy_id/taxons/:taxon_id"]).toEqual(@routes["/taxonomies/:taxonomy_id/taxons/:taxon_id"])

    describe "index handler", ->
      beforeEach ->
        @taxonProductsIndexViewStub = sinon.stub(App.Views.TaxonProducts, "Index").returns(new Backbone.View)

      afterEach ->
        @taxonProductsIndexViewStub.restore()

      it "is fired visiting /taxonomies/:taxonomy_id/taxons/:taxon_id route", ->
        @router.bind("route:index", @routeSpy)
        @router.navigate("/taxonomies/#{@taxonomy_id}/taxons/#{@taxon_id}", true)

      describe "when taxonproducts have already been fetched", ->
        it "does not fetch taxonProducts collection", ->
          expect(@taxonProductsIndexViewStub).not.toHaveBeenCalledOnce()
