describe "new_checkout_step_2 View Mobile", ->
  beforeEach ->
    App.Views.Checkouts.New.Step2.prototype.template = JST["app/assets/javascripts/mobile/templates/checkouts/step/new_step2"]
    @translate = new Backbone.Model
      views:
        cart:
          total_product: "Total product"
        frontend:
          checkout:
            valid_order: "Valid order"
            read_conditions: "Read conditions"
            check_order: "Check_order"
      activerecord:
        attributes:
          shop:
            terms: "Terms"
          order:
            total: "Total"
          product:
            name: "Name"
          product_variant: 
            quantity: "Quantity"
      delivery: "Delivery"
      cancel: "Cancel"

    @carts = new Backbone.Collection({"items":[{"name":"test","quantity":1,"id":5,"picture":{"cached_path":"20130102-1247-53409-8600/Capture_d_e_cran_2012-09-04_a__17.36.39.png","created_at":"2013-01-02T11:47:58Z","id":13,"is_master":true,"picture":{"url":"/uploads/product_variant_picture/picture/13/Capture_d_e_cran_2012-09-04_a__17.36.39.png"},"product_variant_id":5,"updated_at":"2013-01-02T11:47:58Z"},"tax":19.6,"price_ttc":147.11,"product":{"created_at":"2013-01-02T11:18:57Z","deleted_at":null,"depth":null,"height":null,"id":5,"is_master":true,"price":"123.0","product_id":5,"quantity":3,"sku":"12","updated_at":"2013-01-02T11:47:58Z","weight":null,"width":null}}],"shipping":0,"total":147.11,"total_with_shipping":0,"is_deliverable":false})

    @contact = new Backbone.Model
      id: 1
      firstname: "Firstname"
      lastname: "Lastname"
      phone: "Phone"
      contactable_id: 10
      contactable_type: "12"
      created_at: "2013-01-02T11:47:58Z"
      updated_at: "2013-01-02T11:47:58Z"
      addresses_attributes: [
        {
          designation: "designation"
          addr: "addr"
          zip_code: "zip_code"
          country: "country"
          state: "state"
          city: "city"
          created_at: "2013-01-02T11:47:58Z"
          updated_at: "2013-01-02T11:47:58Z"
          addressable_id: "addressable_id"
          addressable_type: "addressable_type"
        }
      ]
      emails_attributes: [
        {
          email: "email"
          contact_id: 1
          created_at: "2013-01-02T11:47:58Z"
          updated_at: "2013-01-02T11:47:58Z"
        }
      ]

    @contactStub = sinon.stub(App, "Contact").returns(@contact)
    @fetchContactStub = sinon.stub(@contact, 'fetch').yieldsTo(@contact)
    @cartsStub = sinon.stub(App.Collections, 'Carts').returns(@carts)
    @fetchCartsStub = sinon.stub(@carts, "fetch").yieldsTo(@carts)
    @translateStub = sinon.stub(App, "Translate").returns(@translate)
    @fetchTranslateStub = sinon.stub(@translate, "fetch").returns(@translate)

    @viewsCheckoutNewStep2 = new App.Views.Checkouts.New.Step2({carts: @carts, contact: @contact, translate: @translate})

  afterEach ->
    @contactStub.restore()
    @fetchContactStub.restore()
    @cartsStub.restore()
    @fetchCartsStub.restore()
    @translateStub.restore()
    @fetchTranslateStub.restore()

  describe "instantiation", ->
    beforeEach ->
      @renderStub = sinon.stub(@viewsCheckoutNewStep2, "render")

    afterEach ->
      @renderStub.restore()

    it "binds on '#app_mobile' element", ->
      expect(@viewsCheckoutNewStep2.$el.selector).toEqual("#app_mobile")

    it "renders immediately", ->
      @viewsCheckoutNewStep2.initialize
        contact: @contact
        carts: @carts
        translate: @translate
      expect(@renderStub).toHaveBeenCalledOnce()

  describe "events", ->
    it "handles correct events", ->
      expect(@viewsCheckoutNewStep2.events).toEqual
        "submit #accept_reglement" : "submit_order"
        "click .roles": "checked_conditions"
        "click #accepts": "checkbox_accept"
        "click #cancel": "cancel"
