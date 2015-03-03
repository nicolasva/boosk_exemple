describe "Model Order", ->
  beforeEach ->
    @order = new App.Order()
    @namespace_facebook = "/"+App.ui()+"/"
    @url_order = "new_order"
    @orders_url = "#{@namespace_facebook}#{@url_order}"
    @order_fixture =
      "address_id":1
      "credit_total":"123.0"
      "email":"nicolas.vandenbogaerde@gmail.com"
      "id":1
      "item_total":"1.0"
      "number":"123"
      "order_id":@order_id
      "paid":false
      "payment_state":"fr"
      "payment_total":"123.0"
      "shop_id":1
      "special_instructions":"special_instrctions"
      "state_id":1
      "total":"1234.0"
      "address":
        "city":"PANTIN"
        "country_id":1
        "address":"12 rue charlot"
        "firstname":"Nicolas"
        "id":1
        "lastname":"VANDENBOGAERDE"
        "state_id":1
        "designation":"au boulot"
        "user_id":1
        "zip_code":"93500"
      "shop":
        "baseline":"test_baseline"
        "created_at":"2012-05-22T08:12:10Z"
        "description":"test_description"
        "devise":"12 EUR"
        "id":1
        "name":"VANDENBOGAERDE"
        "status":true
        "terms":"test_terms"
        "updated_at":"2012-05-22T08:12:10Z"
        "url_website":"http://google.fr"
        "user_id":1
        "uuid":"0287a72a-a55d-eedc-b7e8-6fc9ff3c1764"
      "line_items":[{
        "id":1
        "order_id":1
        "price":"123.0"
        "product_variant_id":1
        "quantity":123
        "product_variant":
          "created_at":"2012-05-22T08:13:46Z"
          "id":1
          "is_master":true
          "price":"123.0"
          "product_id":1
          "quantity":0
          "sku":"123"
          "updated_at":"2012-05-22T08:13:46Z"
      }]

  it "should be defined", ->
    expect(@order).toBeDefined()

  it "can be instantiated", ->
    expect(@order).not.toBeNull()   

  describe "check url", ->
    it "should return the URL", ->
      expect(@order.url()).toEqual(@orders_url)  
   
  describe "order save and fetch", ->
    beforeEach ->
      @server = sinon.fakeServer.create()
      @order = new App.Order(@order_fixture) 
      @server.respondWith(
        "POST"
        @orders_url,
        [
          200,
          {"Content-Type": "application/json"},
          @order_fixture.toString()
        ]
      ) 
      @eventSpy = sinon.spy()
      @order.save() 

    afterEach -> 
      @server.restore()

    it "Should make a save request to the server", ->
      expect(@order.toJSON()).toEqual(@order_fixture)

    it "Should request method PUT ?", ->
      expect(@server.requests[0].method).toEqual("PUT")

    it "Should request url /facebook/country/<country_id>/states/<state_id/addresses/<address_id>/orders ?", ->
      expect(@server.requests[0].url).toEqual(@orders_url)

    it "should request requestBody to equal with order_attributes ?", ->
      expect(JSON.parse(@server.requests[0].requestBody)).toEqual(@order.attributes)
