describe "Product Router Mobile", ->
  beforeEach ->
    App.current_shop = 1
    @optionTypes = new Backbone.Collection
    @optionTypesStub = sinon.stub(App.Collections, 'OptionTypes').returns(@optionTypes)
    @translate = new Backbone.Model
    @translateStub = sinon.stub(App, 'Translate').returns(@translate)
    @router = new App.Routers.Products()
    @product_id = 1

  afterEach ->
    @optionTypesStub.restore()
    @translateStub.restore()

  describe "testing routes exist ?", ->
    beforeEach ->
      @routeSpy = sinon.spy()
      try
        Backbone.history.start({silent: true, pushState: true})
      catch e
      @router.navigate("elsewhere")
      @routes =
        "/products/:uuid": "show"
        "/shops/:shop_id/products": "search"
        "/products/search/hide": "products_search_hide"
    describe "testing routes show", ->
      it "routes testing routing show ?", ->
        expect(@router["routes"]["/products/:uuid"]).toEqual(@routes["/products/:uuid"])

      it "is fired visiting /products/:uuid route", ->
        @router.bind("route:show", @routeSpy)
        @router.navigate("/products/#{@product_id}", true)

    describe "testing routes search", ->
      it "routes testing routing search ?", ->
        expect(@router["routes"]["/shops/:shop_id/products"]).toEqual(@routes["/shops/:shop_id/products"])

      it "is fired visiting /shops/:shop_id/products route", ->
        @router.bind("route:search", @routeSpy)
        @router.navigate("/shops/#{App.current_shop}/products", true)
    
    describe "testing routes products_search_hide", ->
      it "routes testing routing products_search_hide ?", ->
        expect(@router["routes"]["/products/search/hide"]).toEqual(@routes["/products/search/hide"])

      it "is fired visiting /products/search/hide route", ->
        @router.bind("route:products_search_hide", @routeSpy)
        @router.navigate("/products/search/hide", true)

  describe "When initialized", ->
    it "creates a translate instance", ->
      expect(@translateStub).toHaveBeenCalledWithExactly()
      expect(@translateStub).toHaveBeenCalledOnce()

    it "creates a optionTypes instance", ->
      expect(@optionTypesStub).toHaveBeenCalledWithExactly()
      expect(@optionTypesStub).toHaveBeenCalledOnce()

  describe "Products View Application", ->
    describe "when list exists on show", ->
      beforeEach ->
        @view = new Backbone.View
        @model = new Backbone.Model
        @productStub = sinon.stub(App, "Product").returns(@model)
        @showProductViewStub = sinon(App.Views.Products, "Show").returns(@view)
        @router.show("1")

      afterEach ->
        @productStub.restore()
        @showProductViewStub.restore()

    describe "when list exists on search", ->
      beforeEach ->
        @fetchTranslateStub = sinon.stub(@translate, 'fetch').yieldsTo('success', @translate)
        @searchProductsViewStub = sinon(App.Views.Products, "SearchProducts").returns(new Backbone.View)  

      afterEach ->
        @fetchTranslateStub.restore()
        @searchProductsViewStub.restore()
 
