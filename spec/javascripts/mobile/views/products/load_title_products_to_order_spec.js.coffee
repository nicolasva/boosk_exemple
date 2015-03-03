describe "LoadTitleProductsToOrder View products Mobile", ->
  beforeEach ->
    @loadtitleproductstoorderview = App.Views.Products.LoadTitleProductsToOrder
    @backboneView = new Backbone.View
    @backboneRenderSpy = sinon.spy(@backboneView, "render")
    @backboneViewStub = sinon.stub(window['App.Views.Products.LoadTitleProductsToOrder']).returns(@backboneView)

  describe "Rendering", ->
    it "Should create load_title_products_to_order view for each product item", ->
      expect(@backboneViewStub).toHaveBeenCalledThrice

    it "renders each LoadTitleProductsToOrder view", ->
      expect(@backboneRenderSpy).toHaveBeenCalledThrice
