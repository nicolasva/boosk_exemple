describe "add_to_cart view mobile", ->
  beforeEach -> 
    @carts = new Backbone.Collection({"items":[{"name":"test","quantity":1,"id":5,"picture":{"cached_path":"20130102-1247-53409-8600/Capture_d_e_cran_2012-09-04_a__17.36.39.png","created_at":"2013-01-02T11:47:58Z","id":13,"is_master":true,"picture":{"url":"/uploads/product_variant_picture/picture/13/Capture_d_e_cran_2012-09-04_a__17.36.39.png"},"product_variant_id":5,"updated_at":"2013-01-02T11:47:58Z"},"tax":19.6,"price_ttc":147.11,"product":{"created_at":"2013-01-02T11:18:57Z","deleted_at":null,"depth":null,"height":null,"id":5,"is_master":true,"price":"123.0","product_id":5,"quantity":3,"sku":"12","updated_at":"2013-01-02T11:47:58Z","weight":null,"width":null}}],"shipping":0,"total":147.11,"total_with_shipping":0,"is_deliverable":false})
    @product_id = 1
    @quantity = 5
    @product_variant_id = 2
    @data = 
      cart_item: 
        product_id: @product_id
        product_variant_id: @product_variant_id
        quantity: @quantity
    @cartsStub = sinon.stub(App.Collections, "Carts").returns(@carts)
    @fetchCartsStub = sinon.stub(@carts, "fetch").yieldsTo(@carts)
    
    @viewsCartItemsAddToCart = new App.Views.CartItems.AddToCart({carts: @carts, product_id: @product_id, quantity: @quantity, data: @data, product_variant_id: @product_variant_id})
  afterEach ->
    @cartsStub.restore()
    @fetchCartsStub.restore()

  describe "instantiation", ->
    beforeEach ->
      @select_add_to_cart_stub = sinon.stub(@viewsCartItemsAddToCart, "select_add_to_cart")

    afterEach ->
      @select_add_to_cart_stub.restore()
