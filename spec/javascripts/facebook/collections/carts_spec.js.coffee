describe "Carts collection", ->
  beforeEach ->
    App.current_shop = 1
    @cart_url = "/"+App.ui()+"/shops/"+App.current_shop+"/carts"
    @carts = new App.Collections.Carts()
    @cart1_fixture =
      "product":
        "created_at":"2012-11-15T13:42:01Z",
        "deleted_at":null,
        "depth":null,
        "height":null,
        "id":7,
        "is_master":true,
        "price":"1234.0",
        "product_id":7,
        "quantity":1,
        "sku":"123",
        "updated_at":"2012-11-15T13:42:01Z",
        "weight":null,
        "width":null,
      "destroyed":false,
      "stale_state":null,
      "name":"test2",
      "quantity":1
    @cart2_fixture =
      "product":
        "created_at":"2012-11-15T13:42:01Z",
        "deleted_at":null,
        "depth":null,
        "height":null,
        "id":8,
        "is_master":true,
        "price":"1234.0",
        "product_id":8,
        "quantity":2,
        "sku":"123",
        "updated_at":"2012-11-15T13:42:01Z",
        "weight":null,
        "width":null,
      "destroyed":false,
      "stale_state":null,
      "name":"test2",
      "quantity":2

  it "Should be defined", ->
    expect(App.Collections.Carts).toBeDefined()

  it "Should return the cart url", ->
    expect(@carts.url()).toEqual(@cart_url)

  it "Can be instantiated", ->
    expect(@carts).not.toBeNull()

  describe '#fetch', ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe 'request', ->
      beforeEach ->
        @carts.fetch()

      it "can be instantiated", ->
        expect(@carts).not.toBeNull()

      it "requests length equal 1", ->
        expect(@server.requests.length).toEqual(1)

      it "requests method equal GET", ->
        expect(@server.requests[0].method).toEqual("GET")

      it "requests methods url equal /facebook/shops/:shop_id/carts", ->
        expect(@server.requests[0].url).toEqual(@cart_url)

