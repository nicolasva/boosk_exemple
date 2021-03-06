describe "Index View", ->
  beforeEach ->
    @indexview = App.Views.Products.Index

  describe "Rendering", ->
    beforeEach ->
      @backboneView = new Backbone.View
      @backboneRenderSpy = sinon.spy(@backboneView, "render")
      @backboneViewStub = sinon.stub(window['App.Views.Products.Index']).returns(@backboneView)
      @backboneModel1 = new Backbone.Model({id:1, uuid:"3b9ca953-8502-3505-658c-8c0d123fbc14", name: "Product name 1", description: "Description content 1", permalink: "http://shop.boosket.com/product/1", shop_id:1})
      @backboneModel2 = new Backbone.Model({id:2, uuid:"3b9ca953-8502-3505-658c-8c0d123fbc15", name: "Product name 2", description: "Description content 2", permalink: "http://shop.boosket.com/product/2", shop_id:1})
      @backboneModel3 = new Backbone.Model({id:3, uuid:"3b9ca953-8502-3505-658c-8c0d123fbc16", name: "Product name 3", description: "Description content 3", permalink: "http://shop.boosket.com/product/3", shop_id:1})
      @indexview.collection = new Backbone.Collection([
        @backboneModel1,
        @backboneModel2,
        @backboneModel3
      ])
      @indexview.render

    it "Should create a Products view for each product item", ->
      expect(@backboneViewStub).toHaveBeenCalledThrice

    it "renders each Product view", ->
      expect(@backboneRenderSpy).toHaveBeenCalledThrice
