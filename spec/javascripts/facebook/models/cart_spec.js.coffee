describe "Model Cart Facebook", ->
  beforeEach ->
    App.current_shop = 1
    @namespace_facebook = "/"+App.ui()+"/"
    @url_shops = "shops/"
    @page = "show_carts"
    @cart_url = "#{@namespace_facebook}#{@url_shops}#{App.current_shop}/#{@page}"
    @cart = new App.Cart()
    @cart.page = @page
    @cart_fixture =
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
    expect(@cart).toBeDefined()

  it "can be instantiated", ->
    expect(@cart).not.toBeNull()

  describe "check url", ->
    beforeEach ->
      @cart = new App.Cart()
      @cart.url = @cart_url

    it "should return the URL", ->
      expect(@cart.url).toEqual(@cart_url)

  describe "cart save and fetch", ->
    beforeEach ->
      @server = sinon.fakeServer.create()
      @cart_url_with_page = "#{@cart_url}"  
      @cart  = new App.Cart(@cart_fixture)
      @cart.page = @page
      @server.respondWith(
        "GET",
        @cart_url_with_page,
        [
          200,
          {"Content_Type": "application/json"},
          @cart_fixture.toString()
        ]
      )
      @eventSpy = sinon.spy()
      @cart.save()

    afterEach ->
      @server.restore()

    it "should make a save request to the server", ->
      expect(@cart.toJSON()).toEqual(@cart_fixture)

    it "should request url /facebook/shops/<shop_id>/<page> ?", ->
      expect(@server.requests[0].url).toEqual(@cart_url_with_page)

    it "should request requestBody to equal with cart_attributes ?", ->
      expect(JSON.parse(@server.requests[0].requestBody)).toEqual(@cart.attributes)
