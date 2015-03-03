describe "Model ProductVariant", ->
  beforeEach ->
    App.current_shop = 1
    @product_id= 1
    @id = 1
    @url = "/mobile/shops/"+App.current_shop+"/products/"+@product_id+"/product_variants"

  it 'should be defined', ->
    expect(App.ProductVariant).toBeDefined()
  
  it 'can be instantiated', ->
    productvariant = new App.ProductVariant
    expect(productvariant).not.toBeNull()

  describe "check url", ->
    beforeEach ->
      @productVariant = new App.ProductVariant()
      @productVariant.product_id = 1 
    it "should return the productvariant url", ->
      expect(@productVariant.url()).toEqual(@url)

  describe "ProductVariant Fetch", ->
    beforeEach ->
      @product_variant_fixture = 
        "sku" : "test_sku"
        "price" : 123
        "quantity" : 10
        "weight" : 8
        "height" : 8
        "width" : 8
        "depth" : 8
        "is_master": true
        "product_id": @product_id
      @server = sinon.fakeServer.create()
      @productVariant = new App.ProductVariant(@product_variant_fixture)
      @productVariant.product_id = @product_id
      @server.respondWith(
        "POST"
        @url,
        [
          200,
          {"Content-type" : "application/json"},
          @product_variant_fixture.toString()
        ]
      )
      @eventSpy = sinon.spy()
      @productVariant.save()

    afterEach ->
      @server.restore()

    it "should make a save request to the server", ->
      expect(@productVariant.toJSON()).toEqual(@product_variant_fixture)

    it "should request url /mobile/shops/:shop_id/products/:product_id/product_variants ?", ->
      expect(@server.requests[0].url).toEqual(@url)

    it "should request url /product_variants ?", ->
      expect(@server.requests[0].url).toEqual(@url)

    it "should request requestBody to equal with product_variants_attributes ?", ->
      expect(JSON.parse(@server.requests[0].requestBody)).toEqual(@productVariant.attributes)
