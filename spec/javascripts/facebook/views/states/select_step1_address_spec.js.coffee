describe "select_step1_address View", ->
  beforeEach ->
    @selectstep1Addressview = App.Views.States.SelectStep1Address

  describe "Rendering", ->
    beforeEach ->
      @backboneView = new Backbone.View
      @backboneRenderSpy = sinon.spy(@backboneView, "render") 
      @backboneViewStub = sinon.stub(window['App.Views.Products.SelectStep1Address']).returns(@backboneView)
      @backboneModel1 = new Backbone.Model({country_id:1, id: 1,name: "France"})
      @backboneModel2 = new Backbone.Model({country_id:2, id: 4,name: "Allemagne"})
      @backboneModel3 = new Backbone.Model({country_id:3, id: 5,name: "Etats-Unis"})
      @selectstep1Addressview.collection = new Backbone.Collection([
        @backboneModel1,
        @backboneModel2,
        @backboneModel3
      ])
      @selectstep1Addressview.render

    it "Should create a SelectStep1Address view for each select_step1_Address", ->
      expect(@backboneViewStub).toHaveBeenCalledThrice

    it "render each SelectStep1Address view", ->
      expect(@backboneRenderSpy).toHaveBeenCalledThrice
