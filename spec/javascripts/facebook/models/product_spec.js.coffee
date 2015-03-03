describe "Model Product Facebook", ->
  beforeEach ->
    @product_id = 1
    App.current_shop = 1
    @url_shop = "/"+App.ui()+"/shops/"
    @url_product = "/products"
    @all_url = "#{@url_shop}#{App.current_shop}#{@url_product}" 
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
     
  it "should be defined", -> 
    expect(App.Product).toBeDefined()

  it "can be instantiated", ->
    product = new App.Product(id: @product_id)
    expect(product).not.toBeNull()

  describe "check url", ->
    beforeEach ->
      @product = new App.Product
      @product.url = @all_url

    it "should return the URL", ->
      expect(@product.url).toEqual(@all_url)

  describe "product fetch", ->
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

    it "should request requestBody to equal with product_attributes ?", ->

      expect(JSON.parse(@server.requests[0].requestBody)).toEqual(@product.attributes)
