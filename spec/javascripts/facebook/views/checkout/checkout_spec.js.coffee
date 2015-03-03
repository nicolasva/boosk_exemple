describe "checkout view", ->
  beforeEach ->
    App.current_shop = 1
    App.Views.Checkout.Checkout.prototype.template = JST["facebook/templates/checkout/checkout"]
    @translate = new Backbone.Model 
      activerecord: 
        attributes: 
          address: 
            firstname: "Firstname"
            lastname: "Lastname"
            mail: "E-mail"
            designation: "Designation"
            addr: "Addr"
            zip_code: "Zip Code"
            city: "City"
            country: "Country"
          order:
            total: "Total"
          shop:
            terms: "Terms"
      views:
        frontend:
          checkout:
            select_country: "Select Country"
            check_order: "Check Order"
            read_conditions: "Read conditions"
            valid_order: "Valid Order"
      product: "Product"
      price_ttc: "Price ttc"
      delivery: "Delivery"
      cancel: "Cancel"

    @address = new Backbone.Model
      designation: "address designation"
      addr: "30 Rue François Arago"
      zip_code: "93500"
      country: "France"
      state: ""
      city: "PANTIN"
      created_at: "2013-01-02 14:07:22.314246"
      updated_to: "2013-01-02 14:07:22.314246"
      addressable_id: 2
      addressable_type: "Contact"

    @carts = new Backbone.Collection({items: [{name: "test", quantity: '1', id: '1', picture: {cached_path: "20130102-1215-52724-9243/Capture_d_e_cran_2012-09-25_a__16.26.22.png", created_at: "2013-01-02T11:16:01Z", id: '4', is_master: 'true', picture: {url: "/uploads/product_variant_picture/picture/4/Capture_d_e_cran_2012-09-25_a__16.26.22.png"}, product_variant_id: '1', updated_at: "2013-01-08T14:01:31Z"}, tax: '19.6', price_ttc: '147.11', product: {created_at: "2013-01-02T09:57:10Z", deleted_at: 'null', depth: 'null', height: 'null', id: '1', is_master: 'true', price: '123.0', product_id: '1', quantity: '12', sku: '123', updated_at: "2013-01-08T14:01:31Z", weight: 'null', width: 'null'}}], shipping: '0', total: '147.11', total_with_shipping: '0', is_deliverable: 'false'})

    @geographicRegions = new Backbone.Collection([{"name":"Andorre","code":"AD","type":"country","subregions":[{"name":"Canillo","code":"AD|02","type":"parish"},{"name":"Encamp","code":"AD|03","type":"parish"},{"name":"La Massana","code":"AD|04","type":"parish"},{"name":"Ordino","code":"AD|05","type":"parish"}]}])

    @addressStub = sinon.stub(App, "Address").returns(@address)
    @translateStub = sinon.stub(App, "Translate").returns(@translate)
    @cartsStub = sinon.stub(App.Collections, "Carts") .returns(@carts)
    @geographic_regionsStub = sinon.stub(App.Collections, "GeographicRegions").returns(@geographicRegions)
    @fetchAddressStub = sinon.stub(@address, "fetch").yieldsTo(@address)
    @fetchCartsStub = sinon.stub(@carts, "fetch").yieldsTo(@carts)
    @fetchTranslateStub = sinon.stub(@translate, "fetch").yieldsTo(@translate)
    
    @showview = new App.Views.Checkout.Checkout({address: @address, carts: @carts, translate: @translate})
    
  afterEach ->
    @addressStub.restore()
    @translateStub.restore()
    @cartsStub.restore()
    @geographic_regionsStub.restore()
    @fetchAddressStub.restore()
    @fetchCartsStub.restore()
    @fetchTranslateStub.restore()

