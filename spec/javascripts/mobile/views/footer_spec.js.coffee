describe "footer view mobile", ->
  beforeEach ->
    @footerview = App.Views.Footer
    @backboneView = new Backbone.View
    @backboneRenderSpy = sinon.spy(@backboneView, "render")
    @backboneViewStub = sinon.stub(window['App.Views.Footer']).returns(@backboneView)
    @footerview.render

  describe "Rendering", ->
    it "Should create a footer view from each", ->
      expect(@backboneViewStub).toHaveBeenCalledThrice

    it "renders each footer view", ->
      expect(@backboneRenderSpy).toHaveBeenCalledThrice
