describe "show_img_customization customizations mobile view", ->
  beforeEach ->
    @showimgcustomizationview = App.Views.Customizations.ShowImgCustomization
    @backboneView = new Backbone.View
    @backboneRenderSpy = sinon.spy(@backboneView, "render")
    @backboneViewStub = sinon.stub(window['App.Views.Customizations.ShowImgCustomization']).returns(@backboneView)
    @backboneModel1 = new Backbone.Model({id:1, uuid: "acbze2bre3", name: "Shop-test-1", slug: "Shop-test-1", baseline: "baseline 1", description: "description_1", user_id: 1, mobile_status: true, facebook_status: true})
    @backboneModel2 = new Backbone.Model({id: 2, uuid: "acbze2bre3", name: "Shop-test-2", slug: "Shop-test-2", baseline: "baseline 2", description: "description_2", user_id: 1, mobile_status: true, facebook_status: true})
    @backboneModel3 = new Backbone.Model({id: 3, uuid: "acbze2bre3", name: "Shop-test-3", slug: "Shop-test-3", baseline: "baseline 3", description: "description_3", user_id: 1, mobile_status: true, facebook_status: true})
    @showimgcustomizationview.collection = new Backbone.Collection([
      @backboneModel1,
      @backboneModel2,
      @backboneModel3
    ])
    @showimgcustomizationview.render

  describe "Rendering", ->
    it "Should create a show_img_customization view for each shop item ", ->
      expect(@backboneViewStub).toHaveBeenCalledThrice

    it "renders each show_img_customization view", ->
      expect(@backboneRenderSpy).toHaveBeenCalledThrice

