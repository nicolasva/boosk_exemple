describe "Model ProductVariant", ->
  beforeEach ->
    @product_id = 1
    App.current_shop = 1
    @url_all_product_variant = "/shops/#{App.current_shop}/products/#{@product_id}/product_variants"
    @productvariant_fixture =
      "sku":"test_sku"
      "price": 123
      "weight": 1234
      "height": 590
      "width": 700
      "is_master": true
      "product_id": @product_id

  it 'should be defined', ->
    expect(App.ProductVariant).toBeDefined()

  it 'can be instantiated', ->
    productvariant = new App.ProductVariant
    expect(productvariant).not.toBeNull()

  describe "check url", ->
    beforeEach ->
      @productvariant = new App.ProductVariant(product_id: @product_id)

    it "should return the productvariant url", ->
      expect(@productvariant.url()).toEqual(@url_all_product_variant)  

  describe "Productvariant save and fetch", ->
    beforeEach ->
      @server = sinon.fakeServer.create()
      @productvariant = new App.ProductVariant(@productvariant_fixture)

      @server.respondWith(
        "POST"
        @url_all_product_variant,
        [
          200,
          {"Content-type" : "application/json"},
          @productvariant_fixture.toString()
        ]
      )
      @eventSpy = sinon.spy()
      @productvariant.save() 

    afterEach ->
      @server.restore()

    it "should make a save request to the server", ->
      expect(@productvariant.toJSON()).toEqual(@productvariant_fixture)

    it "should request method POST ?", ->
      expect(@server.requests[0].method).toEqual("POST") 

    it "should request url /shops/<shop_id>/products/<product_id>/product_variants", ->
      expect(@server.requests[0].url).toEqual(@url_all_product_variant) 
    it "should request requestBody to equal with productvariant_attributes ?", ->
      expect(JSON.parse(@server.requests[0].requestBody)).toEqual(@productvariant.attributes)

   
  describe "Delete Productvariant", ->
    beforeEach ->
      @productvariant_fixture["id"] = @product_id
      @server = sinon.fakeServer.create()
      @productvariant = new App.ProductVariant(@productvariant_fixture)
      @server.respondWith(
        "DELETE"
        @url_all_product_variant+"/"+@product_id,
        [
          200,
          {"Content-Type" : "application/json"},
          @productvariant_fixture.toString()
        ]
      )
      @eventSpy = sinon.spy()
      @productvariant.destroy

    afterEach ->
      @server.restore()

    it "should delete a request to the server", ->
      expect(@productvariant.toJSON()).toEqual(@productvariant_fixture)

    it "should method server DELETE ?", ->
      expect(@server.responses[0].method).toEqual('DELETE') 

    it "should responses server /shops/<shop_id>/products/<product_id>/product_variants/<productvariant_id>", ->
      expect(@server.responses[0].url).toEqual(@url_all_product_variant+"/"+@product_id)
