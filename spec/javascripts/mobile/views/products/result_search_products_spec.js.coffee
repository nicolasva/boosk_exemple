describe "Result_search_products View products mobile", ->
  beforeEach ->
    @resultsearchproductsview = App.Views.Products.ResultSearchProducts
    @backboneView = new Backbone.View
    @backboneRenderSpy = sinon.spy(@backboneView, "render")
    @backboneViewStub = sinon.stub(window['App.Views.Products.ResultSearchProducts']).returns(@backboneView)

  describe "Rendering", ->
    beforeEach ->
      @backboneModel1 = new Backbone.Model({id:1, uuid:"3b9ca953-8502-3505-658c-8c0d123fbc14", slug: "Product-name-1", name: "Product name 1", status: true, description: "Description content 1", permalink: "http://shop.boosket.com/product/1", shop_id:1, tax_rate_id: 1, shipping_method_id: 1, shipping_category_id: 1})
      @backboneModel2 = new Backbone.Model({id:2, uuid:"3b9ca953-8502-3505-658c-8c0d123fbc15", slug: "Product-name-2", name: "Product name 2", status: true, description: "Description content 2", permalink: "http://shop.boosket.com/product/2", shop_id:1, tax_rate_id: 1, shipping_method_id: 1, shipping_category_id: 1})
      @backboneModel3 = new Backbone.Model({id:3, uuid:"3b9ca953-8502-3505-658c-8c0d123fbc16", slug: "Product-name-2", name: "Product name 3", status: true, description: "Description content 3", permalink: "http://shop.boosket.com/product/3", shop_id:1, tax_rate_id: 1, shipping_method_id: 1, shipping_category_id: 1})
      @resultsearchproductsview.collection = new Backbone.Collection([
        @backboneModel1,
        @backboneModel2,
        @backboneModel3
      ])
      @resultsearchproductsview.render

    it "should create a product search view for each product item", ->
      expect(@backboneViewStub).toHaveBeenCalledThrice

    it "renders each Product search item view", ->
      expect(@backboneRenderSpy).toHaveBeenCalledThrice
