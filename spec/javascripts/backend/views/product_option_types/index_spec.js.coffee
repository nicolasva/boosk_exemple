describe "index View", ->
  beforeEach ->
    @indexview = App.Views.ProductOptionTypes.Index

  describe "Rendering", ->
    beforeEach ->
      @backboneView = new Backbone.View
      @backboneRenderSpy = sinon.spy(@backboneView, "render")
      @backboneViewStub = sinon.stub(window['App.Views.ProductOptionTypes.Index']).returns(@backboneView)
      @backboneModel1 = new Backbone.Model({id:1, name: "name test 1", value: "value_1", shop_id: 1})
      @backboneModel2 = new Backbone.Model({id:2, name: "name test 2", value: "value_2", shop_id: 1}) 
      @backboneModel3 = new Backbone.Model({id:3, name: "name test 3", value: "value_3", shop_id: 1})   
      @indexview.collection = new Backbone.Collection([
        @backboneModel1,
        @backboneModel2,
        @backboneModel3
      ])
      @indexview.render
  
    it "Should create a Dashboard view for each dashboard item", ->
      expect(@backboneViewStub).toHaveBeenCalledThrice

    it "renders each Dashboard view", ->
      expect(@backboneRenderSpy).toHaveBeenCalledThrice
