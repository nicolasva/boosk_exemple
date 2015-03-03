describe "title view mobile", ->
  beforeEach ->
    @titleview = App.Views.Title
    @backboneView = new Backbone.View
    @backboneRenderSpy = sinon.spy(@backboneView, "render")
    @backboneViewStub = sinon.stub(window['App.Views.Title']).returns(@backboneView)
    @titleview
    @titleview.render

  describe "Rendering", ->
    it "Should create a panel view from each title", ->
      expect(@backboneViewStub).toHaveBeenCalledThrice

    it "renders each panel view", ->
      expect(@backboneRenderSpy).toHaveBeenCalledThrice
