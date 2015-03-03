describe "SelectStep1CountryAddress View Facebook", ->
  beforeEach ->
    @selectstep1countryaddressview = App.Views.Country.SelectStep1CountryAddress
  
  describe "Rendering", ->
    beforeEach ->
      @backboneView = new Backbone.View
      @backboneRenderSpy = sinon.spy(@backboneView, "render")
      @backboneViewStub = sinon.stub(window['App.Views.Country.SelectStep1CountryAddress']) 
      @backboneModel1 = new Backbone.Model({id: 1, name: "France"})
      @backboneModel2 = new Backbone.Model({id: 2, name: "Allemagne"})
      @backboneModel3 = new Backbone.Model({id: 3, name: "Espagne"})
      @backboneModel3 = new Backbone.Model({id: 4, name: "Belgique"})
      @selectstep1countryaddressview.collection = new Backbone.Collection([
        @backboneModel1,
        @backboneModel2,
        @backboneModel3
      ])      
      @selectstep1countryaddressview.render

    it "should create a SelectStep1CountryAddressView view for each Select_step1_country_address_view", ->
      expect(@backboneViewStub).toHaveBeenCalledThrice

    it "render each SelectStep1CountryAddressView view", ->
      expect(@backboneRenderSpy).toHaveBeenCalledThrice
