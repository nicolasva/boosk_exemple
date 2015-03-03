describe "index View", ->
  beforeEach ->
    @noticeview = App.Views.Notice

  describe "Rendering", ->
    beforeEach ->
      @backboneView = new Backbone.View
      @backboneRenderSpy = sinon.spy(@backboneView, "render")
      @backboneViewStub = sinon.stub(window['App.Views.Notice']).returns(@backboneView)
      @backboneModel1 = new Backbone.Model({id:1})
      @backboneModel2 = new Backbone.Model({id:2}) 
      @backboneModel3 = new Backbone.Model({id:3})   
      @noticeview.collection = new Backbone.Collection([
        @backboneModel1,
        @backboneModel2,
        @backboneModel3
      ])
      @noticeview.render
  
    it "Should create a Dashboard view for each dashboard item", ->
      expect(@backboneViewStub).toHaveBeenCalledThrice

    it "renders each Dashboard view", ->
      expect(@backboneRenderSpy).toHaveBeenCalledThrice
