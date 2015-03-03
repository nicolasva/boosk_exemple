describe "Listshop View", ->
  beforeEach ->
    @listshopview = App.Views.Listshop

  describe "Rendering", ->
    beforeEach ->
      @backboneView = new Backbone.View
      @backboneRenderSpy = sinon.spy(@backboneView, "render")
      @backboneViewStub = sinon.stub(window['App.Views.Listshop']).returns(@backboneView)
      @backboneModel1 = new Backbone.Model({id:1})
      @backboneModel2 = new Backbone.Model({id:2}) 
      @backboneModel3 = new Backbone.Model({id:3})   
      @listshopview.collection = new Backbone.Collection([
        @backboneModel1,
        @backboneModel2,
        @backboneModel3
      ])
      @listshopview.render
  
    it "Should create a Dashboard view for each dashboard item", ->
      expect(@backboneViewStub).toHaveBeenCalledThrice

    it "renders each Dashboard view", ->
      expect(@backboneRenderSpy).toHaveBeenCalledThrice
