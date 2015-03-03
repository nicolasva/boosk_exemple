describe "Taxonomies Router", ->
  beforeEach ->
    @translate = new Backbone.Model
    @translateStub = sinon.stub(App, 'Translate').returns(@translate)
    @taxonomies = new Backbone.Collection
    @taxonomiesCollectionStub = sinon.stub(App.Collections, "Taxonomies").returns(@taxonomies)
    @products = new Backbone.Collection
    @productsCollectionStub = sinon.stub(App.Collections, "Products").returns(@products)
   
    @router = new App.Routers.Taxonomies

  afterEach ->
    @translateStub.restore()
    @taxonomiesCollectionStub.restore()
    @productsCollectionStub.restore()

  describe "when initialized", ->
    it "creates a taxonomies collection", ->
      expect(@taxonomiesCollectionStub).toHaveBeenCalledOnce()
      expect(@taxonomiesCollectionStub).toHaveBeenCalledWithExactly()

    it "creates a products collection", ->
      expect(@productsCollectionStub).toHaveBeenCalledOnce()
      expect(@productsCollectionStub).toHaveBeenCalledWithExactly()

    it "creates a translate instance", ->
      expect(@translateStub).toHaveBeenCalledOnce()
      expect(@translateStub).toHaveBeenCalledWithExactly()

  describe "routes", ->
    beforeEach ->
      @routes =
        "/taxonomies": "taxonomies"
        "/taxonomies/hide": "taxonomies_hide"
        "/taxonomies/search/:query": "result_search_taxonomies"

      @routeSpy = sinon.spy()
      try
        Backbone.history.start({silent: true, pushState: true})
      catch e
      @router.navigate("elsewhere")

    it  "handels /taxonomies route", ->
      expect(@router["routes"]["/taxonomies"]).toEqual(@routes["/taxonomies"])

    it "handels /taxonomies/hide route", ->
      expect(@router["routes"]["/taxonomies/hide"]).toEqual(@routes["/taxonomies/hide"])

    it "handels /taxonomies/search/:query route", ->
      expect(@router["routes"]["/taxonomies/search/:query"]).toEqual(@routes["/taxonomies/search/:query"])

    describe "taxonomies handler", ->
      beforeEach ->
        @fetchTranslateStub = sinon.stub(@translate, 'fetch').yieldsTo('success', @translate)
        @fetchTaxonomiesStub = sinon.stub(@taxonomies, 'fetch').yieldsTo('success', @taxonomies)
        @taxonomiesIndexViewStub = sinon.stub(App.Views.Taxonomies, "Index").returns(new Backbone.View)

      afterEach ->
        @fetchTranslateStub.restore()
        @fetchTaxonomiesStub.restore()
        @taxonomiesIndexViewStub.restore()

      it "is fired visiting /taxonomies route", ->
        @router.bind("route:taxonomies", @routeSpy)
        @router.navigate("#/taxonomies", true)
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWithExactly()

    describe "taxonomies_hide handler", ->
      it "is fired visiting /taxonomies/hide route", ->
        @router.bind("route:taxonomies_hide", @routeSpy)
        @router.navigate("#/taxonomies_hide", true)

    describe "result_search_taxonomies handler", ->
      beforeEach ->
        @fetchProductsStub = sinon.stub(@products, 'fetch')
        @taxonomiesResultSearchProductsViewStub = sinon.stub(App.Views.Products, "ResultSearchProducts").returns(new Backbone.View)

      afterEach ->
        @fetchProductsStub.restore()
        @taxonomiesResultSearchProductsViewStub.restore()

      it "is fired /taxonomies/search/:query route", ->
        @router.bind("route:result_search_taxonomies", @routeSpy)
        @router.navigate("/taxonomies/search/test", true)

