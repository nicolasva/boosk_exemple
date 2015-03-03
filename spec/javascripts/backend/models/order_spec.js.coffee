describe "Model Order", ->
  beforeEach ->
    App.current_shop = "3c256d22-5628-4e56-bdb0-886170203c23"
    @url = "/shops/#{App.current_shop}/orders"

  it "should be defined", ->
    expect(App.Order).toBeDefined()

  it "can be instantiated", ->
    order = new App.Order
    expect(order).not.toBeNull()

  describe "check url", ->
    beforeEach ->
      @order = new App.Order

    it "should return the shop url", ->
      expect(@order.url()).toEqual(@url)

  describe "Order save and fetch", ->
    beforeEach ->
      @order_fixture =
        "item_total":123
        "total":245
        "credit_total":123.5
        "payment_total":553.4
        "payment_state":"fr"
        "contact_attributes":
          "lastname": "Dupond"
          "firstname": "Jean"
          "phone": "0000000001"
          "addresses_attributes":
            "designation": "home"
            "zip_code": "75003"
            "addr": "10 rue charlot"
            "city": "Paris"
            "state": "îles de france"
          "emails_attributes":
            "email": "jean.dupond@example.com"
        "special_instructions":"special instructions test"
        "shop_id": App.current_shop
      @server = sinon.fakeServer.create()
      @order = new App.Order(@order_fixture)
      @server.respondWith(
        "POST"
        @url,
        [
          200,
          {"Content-type": "application/json"},
          @order_fixture.toString()
        ]
      )
      @eventSpy = sinon.spy()
      @order.save()

    afterEach ->
      @server.restore()

    it "should make a save request to the server", ->
      expect(@order.toJSON()).toEqual(@order_fixture)

    it "should request method POST ?", ->
      expect(@server.requests[0].method).toEqual("POST")

    it "should request requestBody to equal with order_attributes ?", ->
      expect(JSON.parse(@server.requests[0].requestBody)).toEqual(@order.attributes)
