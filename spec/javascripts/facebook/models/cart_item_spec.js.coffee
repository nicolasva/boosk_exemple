describe "Model CartItem facebook", ->
  beforeEach ->
    App.current_shop = 1
    @namespace_facebook = "/"+App.ui()
    @url_shops = "/shops/"
    @page = "add_to_cart"
    @cart_item_url = "#{@namespace_facebook}#{@url_shops}#{App.current_shop}/#{@page}"
    @cart_item = new App.CartItem()
    @cart_item.page = @page
    @cart_item_fixture =
      "cart":
        "created_at": "2012-11-15T13:42:01Z",
        "deleted_at": null,
        "depth": null,
        "height": null,
        "id": 8,
        "is_master": true,
        "price": "1234.0",
        "product_id": 8,
        "quantity": 2,
        "sku": "123",
        "updated_at": "2012-11-15T13:42:01Z",
        "weight": null,
        "width": null,
      "destroyed": false,
      "stale_state": null,
      "name": "test2",
      "quantity": 2

  it "should be defined", ->
    expect(@cart_item).toBeDefined()

  it "can be instantiated", ->
    expect(@cart_item).not.toBeNull()

  describe "check url", ->
    it "should return the URL", ->
      expect(@cart_item.url()).toEqual(@cart_item_url)

  describe "cart_item save and fetch", ->
    beforeEach ->
      @server = sinon.fakeServer.create()
      @cart_item_url_with_page = "#{@cart_item_url}"
      @cart_item = new App.CartItem(@cart_item_fixture)
      @cart_item.page = @page
      @server.respondWith(
        "POST",
        @cart_item_url_with_page,
        [
          200,
          {"Content_type": "application/json"},
          @cart_item_fixture.toString()
        ]
      )
      @eventSpy = sinon.spy()
      @cart_item.save()

    afterEach ->
      @server.restore()

    it "should make a save request to the server", ->
      expect(@cart_item.toJSON()).toEqual(@cart_item_fixture)

    it "should request method POST ?", ->
      expect(@server.requests[0].method).toEqual("POST")

    it "should request url /facebook/shops/:shop_id/:page", ->
      expect(@server.requests[0].url).toEqual(@cart_item_url_with_page)

    it "should request requestBody to equal with cart_item_attributes ?", ->
      expect(JSON.parse(@server.requests[0].requestBody)).toEqual(@cart_item.attributes)
