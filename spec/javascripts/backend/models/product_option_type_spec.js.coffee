describe "Model ProductOptionType", ->
  beforeEach ->
    @productoptiontype_id = 1
    @productoptiontype_fixture =
      "name": "test option_types name"
      "value": "test value option_types"
      "shop_id": App.current_shop
    App.current_shop = 1
    @all_url_product_option_type = "/shops/#{App.current_shop}/option_types"

  it "should be defined", ->
    expect(App.ProductOptionType).toBeDefined()

  it "can be instantiated", ->
    productoptiontype = new App.ProductOptionType
    expect(productoptiontype).not.toBeNull()

  describe "check url", ->
    beforeEach ->
      @productoptiontype = new App.ProductOptionType 

    it "should return the shop url", -> 
      expect(@productoptiontype.url()).toEqual(@all_url_product_option_type)

  describe "productoptiontype save and fetch", ->
    beforeEach ->
      @server = sinon.fakeServer.create()
      @productoptiontype = new App.ProductOptionType(@productoptiontype_fixture)
      @server.respondWith(
        "POST"
        @all_url_product_option_type,
        [
          200,
          {"Content-type" : "application/json"},
          @productoptiontype_fixture.toString()
        ]
      )
      @eventSpy = sinon.spy()
      @productoptiontype.save()
 
    afterEach ->
      @server.restore()

    it "should make a save request to the server", ->
     expect(@productoptiontype.toJSON()).toEqual(@productoptiontype_fixture) 

    it "should request method POST ?", ->
      expect(@server.requests[0].method).toEqual("POST")

    it "should request url /shops/<shop_id>/option_types ?", ->
      expect(@server.requests[0].url).toEqual(@all_url_product_option_type)

    it "should request requestBody to equal with product_option_type_attributes ?", ->
      expect(JSON.parse(@server.requests[0].requestBody)).toEqual(@productoptiontype.attributes)  
    
  describe "delete product_option_type", ->
    beforeEach ->
      @productoptiontype_fixture["id"] = @productoptiontype_id
      @server = sinon.fakeServer.create()
      @productoptiontype = new App.ProductOptionType(@productoptiontype_fixture)
      @server.respondWith(
        "DELETE"
        @all_url_product_option_type+"/"+@productoptiontype_fixture.id,
        [
          200,
          {"Content-Type": "application/json"},
          @productoptiontype_fixture.toString()
        ]
      )
      @eventSpy = sinon.spy()
      @productoptiontype.destroy
 
    afterEach ->
      @server.restore()
    
    it "should delete a request to the server", ->
      expect(@productoptiontype.toJSON()).toEqual(@productoptiontype_fixture)

    it "should method server DELETE ?", ->
      expect(@server.responses[0].method).toEqual('DELETE')

    it "should responses server /shops/<shop_id>/productoptiontypes/<productoptiontype_id>", ->
      expect(@server.responses[0].url).toEqual(@all_url_product_option_type+"/"+@productoptiontype_fixture.id)
