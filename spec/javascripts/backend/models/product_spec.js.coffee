describe "Model Product", ->
  beforeEach ->
    @product_id = 1
    App.current_shop = "3c256d22-5628-4e56-bdb0-886170203c23"
    @all_url = "/shops/#{App.current_shop}/products"
    @product_fixture =
      "name":"Polo lacoste"
      "permalink":"http://lacoste.fr/polo/1"
      "shop_id": App.current_shop
      "status":1
      "product_variants":[{
        "height":"44.0"
        "is_master":true
        "price":"100.0"
        "product_id":1
        "sku":"LAC100"
        "weight":"133.0"
        "width":"66.0"
      }]
      taxon_ids: []
  it 'should be defined', ->
     expect(App.Product).toBeDefined()

  it 'can be instantiated', ->
    product = new App.Product
    expect(product).not.toBeNull()

  describe "check url", ->
    beforeEach ->
      @product = new App.Product

    it "should return the URL", ->
      expect(@product.url()).toEqual(@all_url)

  describe "product save and fetch", ->
    beforeEach ->
      @server = sinon.fakeServer.create()
      @product = new App.Product(@product_fixture)
      @server.respondWith(
        "POST"
        @all_url,
        [
          200,
          {"Content-Type": "application/json"},
          @product_fixture.toString()
        ]
      )
      @eventSpy = sinon.spy()
      @product.save()

    afterEach ->
      @server.restore()

    it "should make a save request to the server", ->
      expect(@product.toJSON()).toEqual(@product_fixture)

    it "should request method POST ?", ->
      expect(@server.requests[0].method).toEqual("POST")

    it "should request url /shops/<shop_id>/products ?", ->
      expect(@server.requests[0].url).toEqual(@all_url)

    it "should request requestBody to equal with product_attributes ?", ->

      expect(JSON.parse(@server.requests[0].requestBody)).toEqual(@product.attributes)

  describe "delete product", ->
    beforeEach ->
      @product_fixture["id"] = @product_id
      @server = sinon.fakeServer.create()
      App.current_shop = 1
      @product = new App.Product(@product_fixture)
      @server.respondWith(
        "DELETE"
        "#{@all_url}/#{@product_id}"
        [
          200,
          {"Content-Type": "application/json"},
          @product_fixture.toString()
        ]
      )
      @eventSpy = sinon.spy()
      @product.destroy

    afterEach ->
      @server.restore()

    it "should delete a request to the server", ->
      expect(@product.toJSON()).toEqual(@product_fixture)

    it "should method server DELETE ?", ->
      expect(@server.responses[0].method).toEqual('DELETE')

    it "should responses server /shops/<shop_id>/products/<product_id>", ->
      expect(@server.responses[0].url).toEqual("#{@all_url}/#{@product_id}")

