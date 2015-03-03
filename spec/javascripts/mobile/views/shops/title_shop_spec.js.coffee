describe "title_shop view", ->
  beforeEach ->
    @titleShopView = App.Views.Shops.TitleShop
    @backboneView = new Backbone.View
    @backboneRenderSpy = sinon.spy(@backboneView, "render")
    @backboneViewStub = sinon.stub(window['App.Views.Shops.TitleShop']).returns(@backboneView)
    @backboneModel1 = new Backbone.Model({id:1, uuid: "acbze2bre3", name: "Shop-test-1", slug: "shop-test-1", baseline: "baseline 1", description: "description_1", user_id: 1, mobile_status: true, facebook_status: false})
    @backboneModel2 = new Backbone.Model({id: 2, uuid: "acbze2bre3", name: "Shop-test-2", slug: "Shop-test-2", baseline: "baseline 2", description: "description_2", user_id: 1, mobile_status: true, facebook_status: false})
    @backboneModel3 = new Backbone.Model({id: 3, uuid: "acbze2bre3", name: "Shop-test-3", slug: "Shop-test-3", baseline: "baseline 3", description: "description_3", user_id: 1, mobile_status: true, facebook_status: false})
    @titleShopView.Collection = new Backbone.Collection([
      @backboneModel1,
      @backboneModel2,
      @backboneModel3
    ])

  describe "Rendering", ->
    beforeEach ->
      @titleShopView.render

    it "Should create a Shops view for each shop item", ->
      expect(@backboneViewStub).toHaveBeenCalledThrice

    it "renders each shops view", ->
      expect(@backboneRenderSpy).toHaveBeenCalledThrice

