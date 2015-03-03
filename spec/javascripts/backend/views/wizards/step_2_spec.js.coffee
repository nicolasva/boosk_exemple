describe "step2 View", ->
  beforeEach ->
    @step2view = App.Views.Wizards.Step2

  describe "Rendering", ->
    beforeEach ->
      @backboneView = new Backbone.View
      @backboneRenderSpy = sinon.spy(@backboneView, "render")
      @backboneViewStub = sinon.stub(window['App.Views.Wizards.Step2']).returns(@backboneView)
      @backboneModel1 = new Backbone.Model({id:1, email: "nicolas.vandenbogaerde1@gmail.com", password: "infonies1"})
      @backboneModel2 = new Backbone.Model({id:2, email: "nicolas.vandenbogaerde2@gmail.com", password: "infonies2"}) 
      @backboneModel3 = new Backbone.Model({id:3, email: "nicolas.vandenbogaerde3@gmail.com", password: "infonies3"})   
      @step2view.collection = new Backbone.Collection([
        @backboneModel1,
        @backboneModel2,
        @backboneModel3
      ])
      @step2view.render
  
    it "Should create a Dashboard view for each dashboard item", ->
      expect(@backboneViewStub).toHaveBeenCalledThrice

    it "renders each Dashboard view", ->
      expect(@backboneRenderSpy).toHaveBeenCalledThrice
