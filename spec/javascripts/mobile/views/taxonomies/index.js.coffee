describe "Index View Taxonomies Mobile", ->
  beforeEach ->
    @taxonomiesview = App.Views.Taxonomies.Index
    @backboneView = new Backbone.View
    @backboneRenderSpy = sinon.spy(@backboneView, "render")
    @backboneViewStub = sinon.stub(window['App.Views.Taxonomies.Index']).returns(@backboneView)
    @backboneModel1 = new Backbone.Model({id: 1, name: "Menu-1", shop_id: 1})
    @backboneModel2 = new Backbone.Model({id: 2, name: "menu-2", shop_id: 1})
    @backboneModel3 = new Backbone.Model({id: 3, name: "menu-3", shop_id: 1})
    @taxonomiesview.collection = new Backbone.Collection([
      @backboneModel1,
      @backboneModel2,
      @backboneModel3
    ])
    @taxonomiesview.render

  it "should create index view for each taxonomies item", ->
    expect(@backboneViewStub).toHaveBeenCalledThrice

  it "renders each taxonomies item view", ->
    expect(@backboneRenderSpy).toHaveBeenCalledThrice
