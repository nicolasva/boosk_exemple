describe "MenuItem View Taxons Mobile", ->
  beforeEach ->
    @menuitemview = App.Views.Taxons.MenuItem
    @backboneView = new Backbone.View
    @backboneRenderSpy = sinon.spy(@backboneView, "render")
    @backboneViewStub = sinon.stub(window['App.Views.Taxons.MenuItem']).returns(@backboneView)
    @backboneModel1 = new Backbone.Model({id: 1, name: "Menu-1", shop_id: 1})
    @backboneModel2 = new Backbone.Model({id: 2, name: "menu-2", shop_id: 1})
    @backboneModel3 = new Backbone.Model({id: 3, name: "menu-3", shop_id: 1})
    @menuitemview.collection = new Backbone.Collection([
      @backboneModel1,
      @backboneModel2,
      @backboneModel3
    ])
    @menuitemview.render


  describe "Rendering", ->
    it "should create  menuitem view for each taxonomies item", ->
      expect(@backboneViewStub).toHaveBeenCalledThrice

    it "renders each Taxonomies item view", ->
      expect(@backboneRenderSpy).toHaveBeenCalledThrice
