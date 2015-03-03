describe "Model Shop", ->
  beforeEach ->
    @user_id = 1
    @url = "/shops"

  it 'should be defined', ->
    expect(App.Shop).toBeDefined()

  it 'can be instantiated', ->
    shop = new App.Shop
    expect(shop).not.toBeNull()

  describe "check url", ->
    beforeEach ->
      @shop = new App.Shop

    it "should return the shop url", ->
      expect(@shop.url()).toEqual(@url)

  describe "shop save and fetch", ->
    beforeEach ->
      @shop_fixture =
        "name":"test_name_shop"
        "baseline":"name_baseline"
        "description":"description shop"
        "has_active_payement": "true"
        "data_product_feed_url": ""
        "url_website": ""
        "user_id": @user_id
      @server = sinon.fakeServer.create()
      @shop = new App.Shop(@shop_fixture)
      @server.respondWith(
        "POST"
        @url,
        [
          200,
          {"Content-type" : "application/json"},
          @shop_fixture.toString()
        ]
      )
      @eventSpy = sinon.spy()
      @shop.save()

    afterEach ->
      @server.restore()

    it "should make a save request to the server", ->
      expect(@shop.toJSON()).toEqual(@shop_fixture)

    it "should request method POST ?", ->
      expect(@server.requests[0].method).toEqual("POST")

    it "should request url /shops ?", ->
      expect(@server.requests[0].url).toEqual(@url)

    it "should request requestBody to equal with shop_attributes ?", ->
      expect(JSON.parse(@server.requests[0].requestBody)).toEqual(@shop.attributes)

  describe "delete shop", ->
    beforeEach ->
      @shop_fixture =
        "id":1
        "name":"test_name_shop"
        "baseline":"name_baseline"
        "description":"description shop"
        "has_active_payement": "true"
        "data_product_feed_url": ""
        "url_website": ""
        "user_id": @user_id

      @server = sinon.fakeServer.create()
      @shop = new App.Shop(@shop_fixture)
      @server.respondWith(
        "DELETE"
        @url+"/"+@shop_fixture.id,
        [
          200,
          {"Content-Type": "application/json"},
          @shop_fixture.toString()
        ]
      )
      @eventSpy = sinon.spy()
      @shop.destroy

    afterEach ->
      @server.restore()

    it "should delete a request to the server", ->
      expect(@shop.toJSON()).toEqual(@shop_fixture)

    it "should method server DELETE ?", ->
      expect(@server.responses[0].method).toEqual('DELETE')

    it "should responses server /shops/<shop_id>", ->
      expect(@server.responses[0].url).toEqual(@url+"/"+@shop_fixture.id)

