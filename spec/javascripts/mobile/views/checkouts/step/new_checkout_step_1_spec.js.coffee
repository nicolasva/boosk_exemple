describe "new_checkout_step_1 View Mobile", ->
  beforeEach ->
    App.Views.Checkouts.New.Step1.prototype.template = JST["app/assets/javascripts/mobile/templates/checkouts/step/new_step1"]
    @translate = new Backbone.Model
      activerecord:
        attributes:
          address:
            firstname: "Firstname"
            lastname: "Lastname"
            mail: "Mail"
            addr: "Addr"
            zip_code: "Zip Code"
            city: "City"
            country: "France"
      views:
        frontend:
          checkout:
            select_country: "Select Country"
      next: "Next"

    @carts = new Backbone.Collection({"items":[{"name":"test","quantity":1,"id":5,"picture":{"cached_path":"20130102-1247-53409-8600/Capture_d_e_cran_2012-09-04_a__17.36.39.png","created_at":"2013-01-02T11:47:58Z","id":13,"is_master":true,"picture":{"url":"/uploads/product_variant_picture/picture/13/Capture_d_e_cran_2012-09-04_a__17.36.39.png"},"product_variant_id":5,"updated_at":"2013-01-02T11:47:58Z"},"tax":19.6,"price_ttc":147.11,"product":{"created_at":"2013-01-02T11:18:57Z","deleted_at":null,"depth":null,"height":null,"id":5,"is_master":true,"price":"123.0","product_id":5,"quantity":3,"sku":"12","updated_at":"2013-01-02T11:47:58Z","weight":null,"width":null}}],"shipping":0,"total":147.11,"total_with_shipping":0,"is_deliverable":false})

    @geographic_regions = new Backbone.Collection([{"name":"Andorre","code":"AD","type":"country","subregions":[{"name":"Canillo","code":"AD|02","type":"parish"},{"name":"Encamp","code":"AD|03","type":"parish"}]}])

    @contact = new Backbone.Model()
  
    @contactStub = sinon.stub(App, "Contact").returns(@contact)
    @translateStub = sinon.stub(App, "Translate").returns(@translate)
    @fetchTranslateStub = sinon.stub(@translate, "fetch").yieldsTo(@translate)
    @cartsStub = sinon.stub(App.Collections, "Carts").returns(@carts)
    @fetchCartsStub = sinon.stub(@carts, "fetch").yieldsTo(@carts)
    @geographicRegionsStub = sinon.stub(App.Collections, "GeographicRegions").returns(@geographic_regions)
    @fetchGeographicRegions = sinon.stub(@geographic_regions, "fetch").yieldsTo(@geographic_regions)

    @viewsCheckoutNewStep1 = new App.Views.Checkouts.New.Step1({translate: @translate, contact: @contact, carts: @carts, geographic_regions: @geographic_regions})

  afterEach ->
    @contactStub.restore()
    @translateStub.restore()
    @fetchTranslateStub.restore()
    @cartsStub.restore()
    @fetchCartsStub.restore()
    @geographicRegionsStub.restore()
    @fetchGeographicRegions.restore()

  describe "instantiation", ->
    beforeEach ->
      @renderStub = sinon.stub(@viewsCheckoutNewStep1, 'render')

    afterEach ->
      @renderStub.restore()

    it "binds on '#app_mobile' element", ->
      expect(@viewsCheckoutNewStep1.$el.selector).toEqual("#app_mobile")

    it "renders immediately", ->
      @viewsCheckoutNewStep1.initialize
        translate: @translate
        contact: @contact
        carts: @carts
        geographic_regions: @geographic_regions
      expect(@renderStub).toHaveBeenCalledOnce()

  describe "events", ->
    it "handles correct events", ->
      expect(@viewsCheckoutNewStep1.events).toEqual
        "submit #new_addresses" : "newStep1"
        "change #address_country" : "select_regions"
