describe "edit cart View Mobile", ->
  beforeEach ->
    App.Views.Cart.Edit.prototype.template = JST["app/assets/javascripts/mobile/templates/cart/edit"] 
   
    @translate = new Backbone.Model
      activerecord:
        attributes:
          product:
            name: "Name"
          product_variant:
            quantity: "Quantity"
      views:
        cart:
          total_product: "Total Product"
          check_out: "Check Out" 
      delete: "delete"
          
    @carts = new Backbone.Collection({"items":[{"name":"test","quantity":1,"id":5,"picture":{"cached_path":"20130102-1247-53409-8600/Capture_d_e_cran_2012-09-04_a__17.36.39.png","created_at":"2013-01-02T11:47:58Z","id":13,"is_master":true,"picture":{"url":"/uploads/product_variant_picture/picture/13/Capture_d_e_cran_2012-09-04_a__17.36.39.png"},"product_variant_id":5,"updated_at":"2013-01-02T11:47:58Z"},"tax":19.6,"price_ttc":147.11,"product":{"created_at":"2013-01-02T11:18:57Z","deleted_at":null,"depth":null,"height":null,"id":5,"is_master":true,"price":"123.0","product_id":5,"quantity":3,"sku":"12","updated_at":"2013-01-02T11:47:58Z","weight":null,"width":null}}],"shipping":0,"total":147.11,"total_with_shipping":0,"is_deliverable":false})

    @cartsStub = sinon.stub(App.Collections, "Carts").returns(@carts)
    @fetchCartsStub = sinon.stub(@carts, "fetch").yieldsTo(@carts)
    @translateStub = sinon.stub(App, "Translate").returns(@translate)
    @fetchTranslateStub = sinon.stub(@translate, "fetch").yieldsTo(@translate)

    @viewsCartEdit = new App.Views.Cart.Edit({translate: @translate, carts: @carts})

  afterEach ->
    @cartsStub.restore()
    @fetchCartsStub.restore()
    @translateStub.restore()
    @fetchTranslateStub.restore()

  describe "instantiation", ->
    beforeEach ->
      @renderStub = sinon.stub(@viewsCartEdit, 'render')

    afterEach ->
      @renderStub.restore()

    it "binds on '#checkout' element", ->
      expect(@viewsCartEdit.$el.selector).toEqual("#checkout")

    it "renders immediately", ->
      @viewsCartEdit.initialize
        translate: @translate
        carts: @carts
      expect(@renderStub).toHaveBeenCalledOnce()

  describe "events", ->
    it "handles correct events", ->
      expect(@viewsCartEdit.events).toEqual
        "click .cart_remove" : "drop_cart"
        "change .cart_items_quantity" : "cartitems_edit"
