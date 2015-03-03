describe "panel view mobile", ->
  beforeEach ->
    @panelview = App.Views.Panel
    @backboneView = new Backbone.View
    @backboneRenderSpy = sinon.spy(@backboneView, "render")
    @backboneViewStub = sinon.stub(window['App.Views.Panel']).returns(@backboneView)
    @panelview.render

  describe "Rendering", ->
    it "Should create a footer view from each", ->
      expect(@backboneViewStub).toHaveBeenCalledThrice

    it "renders each footer view", ->
      expect(@backboneRenderSpy).toHaveBeenCalledThrice
