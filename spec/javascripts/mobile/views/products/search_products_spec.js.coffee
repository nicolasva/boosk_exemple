describe "Search_products Mobile", ->
  beforeEach ->
    @searchproducts = App.Views.Products.SearchProducts

  describe "Rendering", ->
    beforeEach ->
      @backboneView = new Backbone.View
      @backboneRenderSpy = sinon.spy(@backboneView, "render")
      @backboneViewStub = sinon.stub(window['App.Views.Products.SearchProducts']).returns(@backboneView)
      @searchproducts.render

    it "Should create a product view for each searchproducts item", ->
      expect(@backboneViewStub).toHaveBeenCalledThrice

    it "renders each SearchProducts item view", ->
      expect(@backboneRenderSpy).toHaveBeenCalledThrice
