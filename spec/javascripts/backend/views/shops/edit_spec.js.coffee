describe "Edit View", ->
  beforeEach ->
    @editview = App.Views.Shops.Edit

  describe "Rendering", ->
    beforeEach ->
      @backboneView = new Backbone.View
      @backboneRenderSpy = sinon.spy(@backboneView, "render")
      backboneViewStub = sinon.stub(window['App.Views.Shops.Edit']).returns(@backboneView)
      @backboneModel1 = new Backbone.Model({id:1, name: "Shop test 1", baseline: "baseline 1", description: "description_1", user_id: 1})
      @backboneModel2 = new Backbone.Model({id:2, name: "Shop test 2", baseline: "baseline 2", description: "description_2", user_id: 1})
      @backboneModel3 = new Backbone.Model({id:3, name: "Shop test 3", baseline: "baseline 3", description: "description_3", user_id: 1})
      @editview.collection = new Backbone.Collection([
        @backboneModel1,
        @backboneModel2,
        @backboneModel3
      ])
      @editview.render

    it "Should create a Shops view for each shop item", ->
      expect(@backboneViewStub).toHaveBeenCalledThrice

    it "renders each Shops view", ->
      expect(@backboneRenderSpy).toHaveBeenCalledThrice
